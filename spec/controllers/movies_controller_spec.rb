describe MoviesController, type: :controller do
  it "index returns a success response" do
    Movie.stub(:all) {[]}
    get '/movies'
    expect(response.status).to eq 200
  end

  it "show returns a success response" do
    Movie.stub(:find).with('1') { Movie.new(title: 'my test movie')}
    get '/movies/:id', id: 1
    expect(response.status).to eq 200
    expect(JSON.parse(response.body)['title']).to eq 'my test movie'
  end
end
