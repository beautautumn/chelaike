module PlatformProfileHelper
  def yiche_account
    { username: "35050588@qq.com", password: "z5814572" }
  end

  def che168_account
    { username: "13317111783", password: "chelaike123" }
  end

  def com58_account
    { username: "伟伟精品车行", password: "weiwei123" }
  end

  def yiche_profile
    { yiche: { username: yiche_account[:username],
               password: yiche_account[:password],
               default_description: "description",
               bind_time: Time.zone.now,
               contacts: [{ name: "王女士（18334761705）", value: "265875" },
                          { name: "张女士（13834156377）", value: "318034" }],
               is_success: true }
    }
  end

  def che168_profile
    { che168: { username: che168_account[:username],
                password: che168_account[:password],
                default_description: "che168 description",
                bind_time: Time.zone.now,
                contacts: [{ name: "汪成(13317111783)", value: "129132" }],
                is_success: true }
    }
  end

  def com58_profile
    { com58: { username: com58_account[:username],
               password: com58_account[:password],
               default_description: "com58 description",
               bind_time: Time.zone.now,
               contacts: [],
               is_success: true }
    }
  end
end
