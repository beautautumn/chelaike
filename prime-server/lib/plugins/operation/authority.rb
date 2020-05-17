module Operation
  class Authority
    def self.become_to_boss(user)
      if user.authority_type.custom?
        user.update!(authorities: User.authorities)
      else
        boss = user.company.authority_roles.find_by(name: "老板")

        raise "老板不存在" unless boss
        user.authority_role_ids |= ([] << boss.id).flatten
        user.save!
      end
    end
  end
end
