# coding: utf-8
require 'spec_helper'

describe 'ApplicationHelper' do
  
  include EditableSetSpecHelper
  
  before do
    @output_buffer = ''
    mock_everything
  end
  
  describe '#editable_form_for' do
    
    it 'doesn\'t override the normal form builder' do
      form_for(@new_post, :url => '/hello') do |builder|
        builder.class.should == ActionView::Helpers::FormBuilder
      end
    end
    
    it 'uses input tags instead of spans' do
      form_for(@new_post, :url => '/hello') do |builder|
        builder.text_field(:title).should =~ /input/
      end
    end

    it 'yields an instance of EditableSetFormBuilder' do
      editable_form_for(@new_post, :url => '/hello') do |builder|
        builder.class.should == EditableSetFormBuilder
      end
    end
    
    describe 'inputs' do
      describe '#text_field' do
        it 'yields a span' do
          editable_form_for(@new_post, :url => '/hello') do |builder|
            builder.text_field(:title).should =~ /span/
          end
        end
      end
    end
        

    describe 'allows :html options' do
      before(:each) do
         @form = editable_form_for(@new_post, :url => '/hello', :html => { :id => "something-special", :class => "something-extra", :multipart => true }) do |builder|
        end
      end

      it 'to add a id of "something-special" to generated form' do
        pending "webrat integration http://www.ruby-forum.com/topic/212239"
        output_buffer.concat(@form) if rails3?
        output_buffer.should have_tag("form#something-special")
      end

      it 'to add a class of "something-extra" to generated form' do
        pending "webrat integration"
        output_buffer.concat(@form) if rails3?
        output_buffer.should have_tag("form.something-extra")
      end

      it 'to add enctype="multipart/form-data"' do
        pending "webrat integration"
        output_buffer.concat(@form) if rails3?
        output_buffer.should have_tag('form[@enctype="multipart/form-data"]')
      end
    end

    it 'can be called with a resource-oriented style' do
      editable_form_for(@new_post) do |builder|
        builder.object.class.should == ::Post
        builder.object_name.should == "post"
      end
    end
    
    it 'can be called with a generic style and instance variable' do
      if rails3?
        editable_form_for(@new_post, :as => :post, :url => new_post_path) do |builder|
          builder.object.class.should == ::Post
          builder.object_name.to_s.should == "post" # TODO: is this forced .to_s a bad assumption somewhere?
        end
      end
      if rails2?
        semantic_form_for(:post, @new_post, :url => new_post_path) do |builder|
          builder.object.class.should == ::Post
          builder.object_name.to_s.should == "post" # TODO: is this forced .to_s a bad assumption somewhere?
        end
      end
    end

    it 'can be called with a generic style and inline object' do
      editable_form_for(@new_post, :url => new_post_path) do |builder|
        builder.object.class.should == ::Post
        builder.object_name.to_s.should == "post" # TODO: is this forced .to_s a bad assumption somewhere?
      end
    end
    
  end

  describe '#editable_fields_for' do
    it 'yields an instance of SemanticFormBuilder' do
      pending
      semantic_fields_for(@new_post, :url => '/hello') do |builder|
        builder.class.should == ::Formtastic::SemanticFormBuilder
      end
    end
  end

  describe '#semantic_form_remote_for' do
    it 'yields an instance of SemanticFormBuilder' do
      pending
      semantic_form_remote_for(@new_post, :url => '/hello') do |builder|
        builder.class.should == ::Formtastic::SemanticFormBuilder
      end
    end
  end

  describe '#semantic_form_for_remote' do
    it 'yields an instance of SemanticFormBuilder' do
      pending
      semantic_remote_form_for(@new_post, :url => '/hello') do |builder|
        builder.class.should == ::Formtastic::SemanticFormBuilder
      end
    end
  end

end
