require 'test_helper'

class SurveyBlocksControllerTest < ActionController::TestCase
  setup do
    @survey_block = survey_blocks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survey_blocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey_block" do
    assert_difference('SurveyBlock.count') do
      post :create, survey_block: { category: @survey_block.category, weight: @survey_block.weight }
    end

    assert_redirected_to survey_block_path(assigns(:survey_block))
  end

  test "should show survey_block" do
    get :show, id: @survey_block
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey_block
    assert_response :success
  end

  test "should update survey_block" do
    patch :update, id: @survey_block, survey_block: { category: @survey_block.category, weight: @survey_block.weight }
    assert_redirected_to survey_block_path(assigns(:survey_block))
  end

  test "should destroy survey_block" do
    assert_difference('SurveyBlock.count', -1) do
      delete :destroy, id: @survey_block
    end

    assert_redirected_to survey_blocks_path
  end
end
