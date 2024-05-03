# frozen_string_literal: true
# EE fixture

Gitlab::Seeder.quiet do
    token = PersonalAccessToken.new
    token.user_id = User.find_by(username: 'root').id
    token.name = 'api-token-for-testing'
    token.scopes = ["api"]
    token.set_token('ypCa3Dzb23o5nvsixwPA')
    token.save

    print 'OK'
end
