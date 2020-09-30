require 'rails_helper'

RSpec.describe 'Urls', type: :request do
  describe 'POST #create'  do
    context 'with valid params' do
      let(:url_params) { { url: { original_url: 'https://www.test.ru' } } }
      
      it 'get a success status after create a Url' do
        post urls_path, :params => url_params

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
      end

      it 'return short url in body' do
        post urls_path, :params => url_params
        
        expect(JSON.parse(response.body)['short_url'].size).to eq 8
      end

      it 'saves the new url in the database' do
        expect { post urls_path, :params => url_params }.to change(Url, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:url_params) { { url: { original_url: 'https://www.test.ru/   /sdsd' } } }
      
      it 'get a unprocessable_entity status after attempting to create a Url' do
        post urls_path, :params => url_params

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return errors in body' do
        post urls_path, :params => url_params
        
        expect(JSON.parse(response.body)['errors']).to eq ['Original url is invalid']
      end

      it 'doesnt saves the new url in the database' do
        expect { post urls_path, :params => url_params }.to_not change(Url, :count)
      end
    end
  end

  describe 'GET #show'  do
    let!(:url) { create(:url) }

    context 'if requested url exist in database' do
      before do
        get url_path(url.short_url)
      end

      it 'return a success status' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
      end

      it 'return original url in body' do
        expect(JSON.parse(response.body)['original_url']).to eq url.original_url
      end

      it 'increment counter' do
        expect(url.reload.counter).to eq 1
      end

      it 'not change short url after request' do
        short_url = url.short_url
        get url_path(short_url)
        expect(url.reload.short_url).to eq short_url
      end
    end

    context 'if requested url not exist in database' do
      before do
        get url_path('not_existed_url')
      end
      
      it 'get a not_found status after attempting to create a Url' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:not_found)
      end

      it 'return url not found message in request body' do
        expect(JSON.parse(response.body)['errors']).to eq ['url not found']
      end
      
      it 'does not increment counter' do
        expect(url.reload.counter).to eq 0
      end
    end
  end

  describe 'GET #stats'  do
    let!(:url) { create(:url, counter: 5) }

    context 'if requested url exist in database' do
      before do
        get stats_url_path(url.short_url)
      end

      it 'return a success status' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
      end

      it 'return short url in body' do
        expect(JSON.parse(response.body)['url']).to eq url.short_url
      end

      it 'return count in body' do
        expect(JSON.parse(response.body)['count']).to eq url.counter
      end
    end

    context 'if requested url not exist in database' do
      before do
        get stats_url_path('not_existed_url')
      end
      
      it 'get a not_found status after attempting to create a Url' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:not_found)
      end

      it 'return url not found message in request body' do
        expect(JSON.parse(response.body)['errors']).to eq ['url not found']
      end
    end
  end
end
