module Test
  if defined?(TestBench::Bootstrap)
    Fixture = TestBench::Bootstrap::Fixture
  else
    Fixture = TestBench::Fixture
  end
end
