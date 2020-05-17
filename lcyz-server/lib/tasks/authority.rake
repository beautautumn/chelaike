namespace :authority do
  desc "添加新权限"
  # rake authority:add[删除客户,老板]

  task :add, [:name, :role] => :environment do |_t, args|
    role = args[:role]
    authority = args[:name]

    puts "更新公司的角色权限"
    Company.find_each do |company|
      authority_role = company.authority_roles.find_by(name: role)

      if authority_role
        authority_role.authorities << authority
        authority_role.authorities.uniq!
        authority_role.save
      end
    end

    puts "更新用户的角色权限"
    User.find_each do |user|
      found = false
      user.authority_roles.pluck(:name).each do |name|
        found = true if role == name
      end

      user.save if found
    end
  end

  desc "给老板添加车融易相关的权限"
  task add_easy_loan_authorty_to_boss: :environment do
    boss_ids = AuthorityRoleRelationship.where(authority_role_id: AuthorityRole.where(name: "老板").pluck(:id)).pluck(:user_id)
    bosses = User.where(id: boss_ids)

    bosses.each do |boss|
      authorities = (boss.authorities << "融资管理").uniq
      boss.update_columns(authorities: authorities)
      puts "update #{boss.id} done"
    end
  end

  desc "给每个公司的老板角色加上融资管理权限"
  # rake authority:add_easy_loan_authorty_to_boss[融资管理,老板]
  task :add_easy_laon_to_company_boss_authority_role, [:name, :role] => :environment do |_t, args|
    role = args[:role]
    authority = args[:name]

    puts "更新公司的角色权限"
    Company.find_each do |company|
      authority_role = company.authority_roles.find_by(name: role)
      if authority_role
        authority_role.authorities << authority
        authority_role.authorities.uniq!
        authority_role.save
        puts "给 #{company.name} 的 #{role} 角色添加 #{authority} 权限"
      end
    end

    puts "更新尚未有融资管理权限的老板权限"
    boss_ids = AuthorityRoleRelationship.where(authority_role_id: AuthorityRole.where(name: "老板").pluck(:id)).pluck(:user_id)
    bosses = User.where(id: boss_ids)
    bosses.each_with_object(0) do |boss, _|
      unless boss.can?("融资管理")
        authorities = (boss.authorities << "融资管理").uniq
        boss.update_columns(authorities: authorities)
        puts "给 #{boss.company.try(:name)} 的老板 #{boss.name} 添加融资管理权限"
      end
    end
  end
end
