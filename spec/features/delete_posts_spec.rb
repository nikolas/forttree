require 'spec_helper'

describe "DeletePosts" do
  before(:each) do
    @admin = create :admin
    @board = create :board
    @branch = @board.branches.first
  end
  it "should delete a branch and all the leafs" do
    visit "/"
    check "delete_#{@branch.leafs.first.id}"
    fill_in "password", :with => @admin.password
    click_button "Delete"
    page.should have_content 'Branch pruned!'
    Branch.exists?(@branch).should be_false
    Leaf.exists?(@branch.leafs.first).should be_false
  end
  it "should delete just one leaf" do
    @branch.leafs << create(:leaf)
    @leaf = @branch.leafs.first
    visit "/"
    check "delete_#{@leaf.id}"
    fill_in "password", :with => @admin.password
    click_button "Delete"
    page.should have_content 'Leaf pruned!'
    Leaf.exists?(@leaf.id).should be_false
    Branch.exists?(@branch).should be_true
    Leaf.exists?(@branch.leafs.first).should be_true
  end
  it "should not delete branch with wrong password" do
    visit "/"
    check "delete_#{@branch.leafs.first.id}"
    fill_in "password", :with => "WRONGPASSWORD"
    click_button "Delete"
    page.should have_content 'Incorrect password for deletion'
    Branch.exists?(@branch).should be_true
    Leaf.exists?(@branch.leafs.first).should be_true
  end
end
