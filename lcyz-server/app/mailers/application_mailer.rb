class ApplicationMailer < ActionMailer::Base
  default from: "robot@chelaike.com"
  layout "mailer"

  def report(email, hash = {})
    if hash[:attachments].present?
      hash[:attachments].each do |name, file_path|
        attachments[name] = File.read(file_path)
      end
    end

    mail(to: email, subject: hash[:subject])
  end
end
