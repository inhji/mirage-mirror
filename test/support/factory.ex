defmodule Mirage.Factory do
  use ExMachina.Ecto, repo: Mirage.Repo

  def list_factory() do
    title = sequence(:title, &"List-#{&1}")
    slug = Slugger.slugify_downcase(title)

    %Mirage.Lists.List{
      title: title,
      slug: slug,
      content: sequence(:content, &"List Content #{&1}"),
      display_type: :list,
      published_at: ~N[2021-12-03 08:47:00],
      viewed_at: ~N[2021-12-03 08:47:00],
      views: 42
    }
  end

  def user_factory() do
    %Mirage.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: sequence(:password, &"corrent-horse-battery-staple-#{&1}"),
      handle: sequence(:handle, &"handle-#{&1}"),
      name: sequence(:name, &"name-#{&1}"),
      bio: "my life is exiting!",
      pub_key: "Some Public Key",
      priv_key: "Some Private Key",
      microblog_list: build(:list),
      journal_list: build(:list),
      like_list: build(:list),
      bookmark_list: build(:list),
      default_list: build(:list),
      page_list: build(:list),
      article_list: build(:list)
    }
  end
end
