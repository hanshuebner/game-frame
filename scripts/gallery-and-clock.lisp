(loop
  (cl-log:log-message :info "running animations")
  (app:start :gallery)
  (sleep 45)
  (cl-log:log-message :info "running clock")
  (app:start :clock)
  (sleep 15)
  (cl-log:log-message :info "script done"))
