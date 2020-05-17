class AvatarWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(letters, file_name)
    avatar = LetterAvatar.generate letters, 200

    AliyunOss.put(avatar, file_name)

    Util::File.delete(avatar)
  end
end
