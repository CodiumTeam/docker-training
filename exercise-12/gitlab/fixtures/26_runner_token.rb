# frozen_string_literal: true
# EE fixture

Gitlab::Seeder.quiet do
    runner = Ci::Runner.new
    runner.runner_type = 'instance_type'
    runner.run_untagged = true
    runner.description = "example runner for docker-compose"
    runner.locked = false
    runner.access_level = 'not_protected'
    runner.set_token('glrt-thid3iZua6lohthu3AhW')
    runner.registration_type = 'authenticated_user'
    runner.creator_id = 1
    runner.save
end
