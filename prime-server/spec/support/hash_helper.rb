module HashHelper
  # DEBUG Helper
  def diff_hash(hash1, hash2)
    hash1.each do |k, v|
      next if v == hash2[k]

      puts <<-INFO.strip_heredoc
        --------------------------------------
        Key: #{k}
        希望得到 #{v}  --- #{v.class.name}
        但得到了 #{hash2[k]} --- #{hash2[k].class.name}
        --------------------------------------
      INFO
    end
  end
end
