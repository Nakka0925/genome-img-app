require 'test_helper'

class OrganismsControllerTest < ActionDispatch::IntegrationTest
  test "should get database" do
    get organisms_database_url
    assert_response :success
  end

end
