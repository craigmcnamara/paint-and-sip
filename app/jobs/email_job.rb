class EmailJob
  include SuckerPunch::Job

  def perform(email_class, method, *args)
    email_class.to_s.classify.constantize.send(method, *args).deliver
  end
end