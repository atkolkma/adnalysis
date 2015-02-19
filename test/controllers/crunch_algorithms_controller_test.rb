require 'test_helper'

class CrunchAlgorithmsControllerTest < ActionController::TestCase
  setup do
    @crunch_algorithm = crunch_algorithms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crunch_algorithms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crunch_algorithm" do
    assert_difference('CrunchAlgorithm.count') do
      post :create, crunch_algorithm: { functions: @crunch_algorithm.functions, name: @crunch_algorithm.name, report_id: @crunch_algorithm.report_id, type: @crunch_algorithm.type }
    end

    assert_redirected_to crunch_algorithm_path(assigns(:crunch_algorithm))
  end

  test "should show crunch_algorithm" do
    get :show, id: @crunch_algorithm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @crunch_algorithm
    assert_response :success
  end

  test "should update crunch_algorithm" do
    patch :update, id: @crunch_algorithm, crunch_algorithm: { functions: @crunch_algorithm.functions, name: @crunch_algorithm.name, report_id: @crunch_algorithm.report_id, type: @crunch_algorithm.type }
    assert_redirected_to crunch_algorithm_path(assigns(:crunch_algorithm))
  end

  test "should destroy crunch_algorithm" do
    assert_difference('CrunchAlgorithm.count', -1) do
      delete :destroy, id: @crunch_algorithm
    end

    assert_redirected_to crunch_algorithms_path
  end
end
