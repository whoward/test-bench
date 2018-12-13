require_relative './test_init'

if defined?(TestBench::Bootstrap)
  TestBench::Bootstrap::CLI.()
else
  fail "Runner is not yet implemented"
end
