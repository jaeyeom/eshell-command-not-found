;;; test-eshell-command-not-found.el --- Tests for eshell-command-not-found  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Jaehyun Yeom

;; Author: Jaehyun Yeom <jae.yeom@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(require 'ert)
(require 'eshell-command-not-found)

(defun setup-temporary-command-not-found ()
  "Create a temporary script file for `eshell-command-not-found'."
  (let ((temp-file (make-temp-file "eshell-command-not-found-test")))
    (with-temp-file temp-file
      (insert "#!/bin/sh\n")
      (insert "echo \"Custom error: $1\""))
    (set-file-modes temp-file #o755)
    temp-file))

(ert-deftest eshell-command-not-found--is-minor-mode ()
  (should (memq 'eshell-command-not-found-mode minor-mode-list)))

(ert-deftest eshell-command-not-found--should-error ()
  (let ((eshell-command-not-found-command (setup-temporary-command-not-found)))
    (unwind-protect
        (condition-case err
            (eshell-command-not-found "foo")
          (error (should (string= "Custom error: foo" (error-message-string err)))))
      (delete-file eshell-command-not-found-command))))

(ert-deftest eshell-command-not-found--mode-enable-failure ()
  (let ((eshell-command-not-found-command nil))
    (should-error (eshell-command-not-found-mode 1))))

(ert-deftest eshell-command-not-found--mode-toggle ()
  (let ((eshell-command-not-found-command (setup-temporary-command-not-found)))
    (unwind-protect
        (progn
          (remove-hook #'eshell-command-not-found eshell-alternate-command-hook)
          (eshell-command-not-found-mode 1)
          (should (memq #'eshell-command-not-found eshell-alternate-command-hook))
          (eshell-command-not-found-mode -1)
          (should-not (memq #'eshell-command-not-found eshell-alternate-command-hook)))
      (delete-file eshell-command-not-found-command))))

(provide 'test-eshell-command-not-found)
;;; test-eshell-command-not-found.el ends here
