require 'test_helper'

class FunctionSetsControllerTest < ActionController::TestCase
  setup do
    @functional_composition = functional_compositions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:functional_compositions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create functional_composition" do
    assert_difference('FunctionSet.count') do
      post :create, functional_composition: { composition_set: @functional_composition.composition_set, name: @functional_composition.name, report_id: @functional_composition.report_id, type: @functional_composition.type }
    end

    assert_redirected_to functional_composition_path(assigns(:functional_composition))
  end

  test "should show functional_composition" do
    get :show, id: @functional_composition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @functional_composition
    assert_response :success
  end

  test "should update functional_composition" do
    patch :update, id: @functional_composition, functional_composition: { composition_set: @functional_composition.composition_set, name: @functional_composition.name, report_id: @functional_composition.report_id, type: @functional_composition.type }
    assert_redirected_to functional_composition_path(assigns(:functional_composition))
  end

  test "should destroy functional_composition" do
    assert_difference('FunctionSet.count', -1) do
      delete :destroy, id: @functional_composition
    end

    assert_redirected_to functional_compositions_path
  end
end
