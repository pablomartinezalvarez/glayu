defmodule Glayu.PreviewServer.Plug.ServerTest do

  use ExUnit.Case
  use Plug.Test

  @opts Glayu.PreviewServer.Plug.Server.init([])

  @home_html "<html>\n<head><title>The Glayu Times</title></head>\n<body>\n\n<h1>The Glayu Times</h1>\n<h2>Home Page</h2>\n🐦 <a class=\"fechu-cun-glayu\" href=\"https://github.com/pmartinezalvarez/glayu\"> fechu con glayu</a>\n\n</body>\n</html>\n"
  @draft_01_html "<html>\n<head><title>Draft 01</title></head>\n<body>\n\n<h1>The Glayu Times</h1>\n<p>Nemo voluptatibus illum similique dolore. Quos cum neque et. Mollitia quis iusto cum sapiente. Vitae id omnis voluptatem dolor tenetur. Labore ut officiis accusantium eaque. Quos id eius at recusandae deleniti aperiam est.\nVel aut blanditiis ipsum aut eum ab praesentium voluptatibus. Ullam quo quis numquam et explicabo ipsum est. Ducimus facilis odio quia nostrum.\nSed et laboriosam ea atque nihil qui temporibus. Illo fugiat animi ut aut vel dignissimos animi quo. Ea numquam aut rem debitis. Culpa sint voluptatem qui. Iusto necessitatibus illo facilis commodi explicabo ut.\nA mollitia eum et voluptatem nemo. Suscipit esse repudiandae amet aliquid alias sit omnis itaque. Dolores molestiae vitae sit. Veniam hic doloremque qui tempore ducimus qui. Incidunt optio optio dolorem molestias dolor voluptas vitae. Ut omnis est omnis nulla quia quidem iusto.\nReprehenderit eum veniam voluptas architecto tempora sed veniam. Consectetur nemo et velit delectus voluptatem voluptas pariatur autem. Perspiciatis ipsam est recusandae. Ratione amet hic perferendis.</p>\n\n🐦 <a class=\"fechu-cun-glayu\" href=\"https://github.com/pmartinezalvarez/glayu\"> fechu con glayu</a>\n\n</body>\n</html>\n"
  @post_01_html "<html>\n<head><title>Post 01</title></head>\n<body>\n\n<h1>The Glayu Times</h1>\n<p>Nemo voluptatibus illum similique dolore. Quos cum neque et. Mollitia quis iusto cum sapiente. Vitae id omnis voluptatem dolor tenetur. Labore ut officiis accusantium eaque. Quos id eius at recusandae deleniti aperiam est.\nVel aut blanditiis ipsum aut eum ab praesentium voluptatibus. Ullam quo quis numquam et explicabo ipsum est. Ducimus facilis odio quia nostrum.\nSed et laboriosam ea atque nihil qui temporibus. Illo fugiat animi ut aut vel dignissimos animi quo. Ea numquam aut rem debitis. Culpa sint voluptatem qui. Iusto necessitatibus illo facilis commodi explicabo ut.\nA mollitia eum et voluptatem nemo. Suscipit esse repudiandae amet aliquid alias sit omnis itaque. Dolores molestiae vitae sit. Veniam hic doloremque qui tempore ducimus qui. Incidunt optio optio dolorem molestias dolor voluptas vitae. Ut omnis est omnis nulla quia quidem iusto.\nReprehenderit eum veniam voluptas architecto tempora sed veniam. Consectetur nemo et velit delectus voluptatem voluptas pariatur autem. Perspiciatis ipsam est recusandae. Ratione amet hic perferendis.</p>\n\n🐦 <a class=\"fechu-cun-glayu\" href=\"https://github.com/pmartinezalvarez/glayu\"> fechu con glayu</a>\n\n</body>\n</html>\n"
  @europe_category_html "<html>\n<head><title>Europe</title></head>\n<body>\n\n<h1>The Glayu Times</h1>\n<h2>Categories Page</h2>\n🐦 <a class=\"fechu-cun-glayu\" href=\"https://github.com/pmartinezalvarez/glayu\"> fechu con glayu</a>\n\n</body>\n</html>\n"
  @sitemap_page_html "<html>\n<head><title>Site Map</title></head>\n<body>\n\n<h1>The Glayu Times</h1>\n<p>Nemo voluptatibus illum similique dolore. Quos cum neque et. Mollitia quis iusto cum sapiente. Vitae id omnis voluptatem dolor tenetur. Labore ut officiis accusantium eaque. Quos id eius at recusandae deleniti aperiam est.\nVel aut blanditiis ipsum aut eum ab praesentium voluptatibus. Ullam quo quis numquam et explicabo ipsum est. Ducimus facilis odio quia nostrum.\nSed et laboriosam ea atque nihil qui temporibus. Illo fugiat animi ut aut vel dignissimos animi quo. Ea numquam aut rem debitis. Culpa sint voluptatem qui. Iusto necessitatibus illo facilis commodi explicabo ut.\nA mollitia eum et voluptatem nemo. Suscipit esse repudiandae amet aliquid alias sit omnis itaque. Dolores molestiae vitae sit. Veniam hic doloremque qui tempore ducimus qui. Incidunt optio optio dolorem molestias dolor voluptas vitae. Ut omnis est omnis nulla quia quidem iusto.\nReprehenderit eum veniam voluptas architecto tempora sed veniam. Consectetur nemo et velit delectus voluptatem voluptas pariatur autem. Perspiciatis ipsam est recusandae. Ratione amet hic perferendis.</p>\n\n🐦 <a class=\"fechu-cun-glayu\" href=\"https://github.com/pmartinezalvarez/glayu\"> fechu con glayu</a>\n\n</body>\n</html>\n"

  setup_all do

    Application.start(:yamerl)
    Glayu.Supervisor.start_link
    Glayu.Build.Supervisor.start_link

    Glayu.Config.load_config_file("./test/fixtures/preview_server/_config.yml", "./test/fixtures/preview_server")
    Glayu.Build.TemplatesStore.add_templates(Glayu.Template.compile())
    SiteHelper.gen_test_site("preview_server")
    SiteHelper.build_site_tree()

    on_exit fn ->
      File.rm_rf!("./test/fixtures/preview_server/source/")
    end

  end

  test "/ returns the home page" do

    conn = conn(:get, "/")
      |> Glayu.PreviewServer.Plug.Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == @home_html

  end

  test "/index.html returns the home page" do

    conn = conn(:get, "/index.html")
      |> Glayu.PreviewServer.Plug.Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == @home_html

  end

  test "/_drafts/draft-01.html returns the draft-01 page" do

    conn = conn(:post, "/_drafts/draft-01.html")
      |> Glayu.PreviewServer.Plug.Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == @draft_01_html

  end

  test "/world/europe/2017/01/01/post-01.html returns the post-01 page" do

    conn = conn(:post, "/world/europe/2017/01/01/post-01.html")
      |> Glayu.PreviewServer.Plug.Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == @post_01_html

  end

  test "/_posts/world/europe/2017/01/01/post-01.html returns the post-01 page" do

    conn = conn(:post, "/_posts/world/europe/2017/01/01/post-01.html")
      |> Glayu.PreviewServer.Plug.Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == @post_01_html

  end

  test "/sitemap.html returns the sitemap page" do

    conn = conn(:post, "/sitemap.html")
      |> Glayu.PreviewServer.Plug.Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == @sitemap_page_html

  end

  test "/world/europe/index.html returns the World > Europe category page" do

    conn = conn(:post, "/world/europe/index.html")
      |> Glayu.PreviewServer.Plug.Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == @europe_category_html

  end

  test "/world/europe/ returns the World > Europe category page" do

    conn = conn(:post, "/world/europe/")
      |> Glayu.PreviewServer.Plug.Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == @europe_category_html

  end

  test "/page/unknown.html returns a 404 error response" do

    conn = conn(:post, "/page/unknown.html")
      |> Glayu.PreviewServer.Plug.Server.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404

  end


end