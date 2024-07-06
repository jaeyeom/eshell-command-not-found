;;; eshell-command-not-found.el --- Integrate command-not-found in eshell  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Jaehyun Yeom

;; Author: Jaehyun Yeom <jae.yeom@gmail.com>
;; Package-Requires: ((emacs "25.1"))
;; Keywords: convenience
;; URL: https://github.com/jaeyeom/eshell-command-not-found
;; Version: 0.1

;; SPDX-License-Identifier: GPL-3.0-or-later

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;; This package integrates command-not-found in eshell.  It suggests
;; packages to install when a command is not found.
;;
;; Requirements:
;; - command-not-found
;;
;; Usage:
;;
;; In `eshell' buffer, if you type a command that is not found, it would suggest
;; you to install the package that provides the command.
;;
;; You can customize `eshell-command-not-found-command' to set the path to the
;; command-not-found executable.  The default value is determined by checking a
;; few common paths.
;;
;; To enable this feature, you can either use `eshell-command-not-found-mode' or
;; customize `eshell-command-not-found-mode' to `t'.

;;; Code:

(require 'esh-ext)

;;;###autoload
(defcustom eshell-command-not-found-command
  (seq-find 'file-executable-p
            '("/data/data/com.termux/files/usr/libexec/termux/command-not-found"
              "/usr/lib/command-not-found"
              "/usr/libexec/pk-command-not-found"))
  "Path to command-not-found executable."
  :type 'string
  :group 'eshell-mode)

(defun eshell-command-not-found (command)
  "Hook to run command-not-found script in eshell.
Argument COMMAND is the not found command."
  (error (string-trim-right
          (shell-command-to-string
           (format "%s %s"
                   eshell-command-not-found-command
                   (shell-quote-argument command))))))

;;;###autoload
(define-minor-mode eshell-command-not-found-mode
  "Toggle command-not-found integration on `eshell-mode'."
  :group 'eshell-mode
  :init-value nil
  :lighter nil
  (if eshell-command-not-found-mode
      (if eshell-command-not-found-command
          (add-hook 'eshell-alternate-command-hook #'eshell-command-not-found)
        (progn
          (setq eshell-command-not-found-mode nil)
          (error "Variable eshell-command-not-found-command is not properly set")))
    (remove-hook 'eshell-alternate-command-hook #'eshell-command-not-found)))

(defun eshell-command-not-found-mode-on ()
  "Turn on `eshell-command-not-found-mode'."
  (when (derived-mode-p 'eshell-mode)
    (eshell-command-not-found-mode 1)))

;;;###autoload
(defcustom eshell-command-not-found-mode nil
  "Toggle command-not-found integration on `eshell-mode'.
Setting this variable directly does not take effect;
use either \\[customize] or function `eshell-command-not-found-mode'."
  :set (lambda (_ value)
         (eshell-command-not-found-mode (if value 1 -1)))
  :initialize 'custom-initialize-default
  :type 'boolean
  :group 'eshell-mode
  :require 'eshell-command-not-found)

(provide 'eshell-command-not-found)
;;; eshell-command-not-found.el ends here
