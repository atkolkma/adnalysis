require 'test_helper'

class SourceFilesControllerTest < ActionController::TestCase
  setup do
    @source_file = source_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:source_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create source_file" do
    assert_difference('SourceFile.count') do
      post :create, source_file: {  }
    end

    assert_redirected_to source_file_path(assigns(:source_file))
  end

  test "should show source_file" do
    get :show, id: @source_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @source_file
    assert_response :success
  end

  test "should update source_file" do
    patch :update, id: @source_file, source_file: {  }
    assert_redirected_to source_file_path(assigns(:source_file))
  end

  test "should destroy source_file" do
    assert_difference('SourceFile.count', -1) do
      delete :destroy, id: @source_file
    end

    assert_redirected_to source_files_path
  end
end
