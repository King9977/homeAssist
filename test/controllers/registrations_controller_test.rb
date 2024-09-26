require 'test_helper'
require 'mocha/minitest'

class ResourcesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @group = mock('group')
    @resource = mock('resource')
    @user = mock('user')

    @group.stubs(:id).returns(1)
    @group.stubs(:resources).returns([@resource])
    @group.stubs(:group_admins).returns([@user])
    @group.stubs(:admin?).returns(true)

    @resource.stubs(:id).returns(1)
    @resource.stubs(:name).returns("Test Resource")
    @resource.stubs(:quantity).returns(10)

    ResourcesController.any_instance.stubs(:set_group).returns(@group)
    ResourcesController.any_instance.stubs(:set_resource).returns(@resource)
    ResourcesController.any_instance.stubs(:current_user).returns(@user)
    ResourcesController.any_instance.stubs(:require_login).returns(true)
  end

  test "should get index" do
    get group_resources_url(group_id: @group.id)
    assert_response :success
    assert_equal [@resource], assigns(:resources)
  end

  test "should get new" do
    get new_group_resource_url(group_id: @group.id)
    assert_response :success
  end

  test "should create resource" do
    @group.resources.stubs(:build).returns(@resource)
    @resource.stubs(:save).returns(true)

    post group_resources_url(group_id: @group.id), params: { resource: { name: 'New Resource', quantity: 5 } }
    assert_redirected_to group_resources_url(@group)
    assert_equal 'Ressource wurde erfolgreich erstellt.', flash[:notice]
  end

  test "should not create resource with invalid data" do
    @group.resources.stubs(:build).returns(@resource)
    @resource.stubs(:save).returns(false)

    post group_resources_url(group_id: @group.id), params: { resource: { name: '', quantity: 5 } }
    assert_template :new
  end

  test "should get edit" do
    get edit_group_resource_url(group_id: @group.id, id: @resource.id)
    assert_response :success
  end

  test "should update resource" do
    @resource.stubs(:update).returns(true)

    patch group_resource_url(group_id: @group.id, id: @resource.id), params: { resource: { name: 'Updated Resource', quantity: 15 } }
    assert_redirected_to group_resources_url(@group)
    assert_equal 'Ressource wurde erfolgreich aktualisiert.', flash[:notice]
  end

  test "should not update resource with invalid data" do
    @resource.stubs(:update).returns(false)

    patch group_resource_url(group_id: @group.id, id: @resource.id), params: { resource: { name: '', quantity: 15 } }
    assert_template :edit
  end

  test "should destroy resource" do
    @resource.stubs(:destroy).returns(true)

    delete group_resource_url(group_id: @group.id, id: @resource.id)
    assert_redirected_to group_resources_url(@group)
    assert_equal 'Ressource wurde erfolgreich gelöscht.', flash[:notice]
  end

  test "should not destroy resource if not admin" do
    @group.stubs(:admin?).returns(false)

    delete group_resource_url(group_id: @group.id, id: @resource.id)
    assert_redirected_to group_resources_url(@group)
    assert_equal 'Nur Gruppenadmins können Ressourcen löschen.', flash[:alert]
  end
end
