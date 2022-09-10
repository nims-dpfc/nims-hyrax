module PathDefine
  def fixture_path
    @fixture_path ||= "#{::Rails.root}/spec/fixtures"
  end
end

World(PathDefine)