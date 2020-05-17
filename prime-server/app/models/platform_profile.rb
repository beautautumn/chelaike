# == Schema Information
#
# Table name: platform_profiles
#
#  id         :integer          not null, primary key
#  company_id :integer                                # 公司ID
#  data       :jsonb                                  # 账号信息
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PlatformProfile < ActiveRecord::Base
  # data: {"ganji"=>{
  #   "password"=>"12344321",
  #   "username"=>"sadf",
  #   bind_time: time,
  #   is_success: true | false}}
  store_accessor :data, :yiche, :com58, :che168, :ganji

  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  def contact_person_params(platform, contact_value)
    platform = platform.to_s
    case platform
    when "yiche", "che168"
      outside_contact(platform, contact_value)
    when "com58", "ganji"
      inner_contact(contact_value)
    end
  end

  def binded?(platform)
    obj_hash = send(platform)
    obj_hash.present? && obj_hash.fetch("is_success", false)
  end

  # data = { username: "asdf", password: "1234", default_description: "saeffdsa" }
  def update_profile(platform, data)
    send("#{platform}=", data)
    save!
  end

  def username(platform)
    obj_hash = send(platform)
    binded?(platform) ? obj_hash.fetch("username") : ""
  end

  def password(platform)
    obj_hash = send(platform)
    binded?(platform) ? obj_hash.fetch("password") : ""
  end

  def contacts(platform)
    obj_hash = send(platform)
    binded?(platform) ? obj_hash.fetch("contacts") : []
  end

  def update_extras(platform, options)
    obj_hash = send(platform)
    options.each do |key, value|
      obj_hash[key] = value
    end

    save!
  end

  def unbind(platform)
    obj_hash = send(platform)
    return if obj_hash.blank?
    obj_hash.keep_if { |key, _value| key == "default_description" }

    save!
  end

  private

  def outside_contact(platform, contact_value)
    platform_profile = public_send(platform)
    contacts = platform_profile.fetch("contacts", "#{platform}_profile_has_no_contacts")
    contact_value = contacts.find do |contact|
      contact.fetch("value").to_s == contact_value.to_s
    end # {"name"=>"王女士（18334761705）", "value"=>"265875"}

    {
      contact_person_name: contact_value.fetch("name"),
      contact_person_id: contact_value.fetch("value")
    }.stringify_keys
  end

  def inner_contact(contact_value)
    user = User.find(Integer(contact_value))

    { contact_person_name: user.name, contact_mobile: user.phone }
  end
end
