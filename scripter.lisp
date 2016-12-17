;; -*- Lisp -*-

(defpackage :scripter
  (:use :cl :alexandria)
  (:export #:start))

(in-package :scripter)

(defun play-all ()
  (setf *random-state* (make-random-state t))
  (loop
    (cl-log:log-message :info "Scanning GIF directory")
    (let ((gifs (directory #P"gifs/*.gif"))
          (last-update (file-write-date #P"gifs/")))
      (loop
        (let ((gif (alexandria:random-elt gifs)))
          (cl-log:log-message :info "Loading ~A" gif)
          (handler-case
              (messaging:send :display :set-animation (display:load-gif gif))
            (error (e)
              (cl-log:log-message :error "Error loading gif ~A~%~A~%" gif e)
              (sleep .5))))
        (sleep 30)
        (when (/= last-update (file-write-date #P"gifs/"))
          (return))))))

(defun start ()
  (messaging:make-agent :scripter
                        (lambda ()
                          (loop
                            (messaging:make-agent :app 'play-all)
                            (messaging:wait-for '(:key-pressed :key-power) :from :remote-control-reader)
                            (messaging:exit :agent-name :app)
                            (messaging:wait-for '(:exit) :from :app)
                            (messaging:send :display :blank)
                            (messaging:wait-for '(:key-pressed :key-power) :from :remote-control-reader)))))