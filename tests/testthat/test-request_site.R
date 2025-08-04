laura <- system.file("testdata", "Laura_S.json", package = "james")
laura_gro <- system.file("testdata", "Laura_S_gro.json", package = "james")
laura_dev <- system.file("testdata", "Laura_S_dev.json", package = "james")
laura_dev_2 <- system.file("testdata", "Laura_S_dev_2.json", package = "james")

kevin <- system.file("testdata", "Kevin_S.json", package = "james")
kevin_gro <- system.file("testdata", "Kevin_S_gro.json", package = "james")
kevin_dev <- system.file("testdata", "Kevin_S_dev.json", package = "james")

host <- "http://localhost:8080"

if (jamesclient::valid_url(host)) {
  test_that(
    "creates site_laura",
    expect_true(jamesclient::valid_url(request_site(txt = laura, sitehost = host)))
  )

  #site_laura_gro <- request_site(laura_gro, sitehost = host)
  #site_laura_dev <- request_site(laura_dev, sitehost = host)
  #site_laura_dev_2 <- request_site(laura_dev_2, sitehost = host)

  test_that(
    "creates site_kevin",
    expect_true(jamesclient::valid_url(request_site(txt = kevin, sitehost = host)))
  )

  # site_kevin_gro <- request_site(kevin_gro, sitehost = host)
  # site_kevin_dev <- request_site(kevin_dev, sitehost = host)

  # browseURL(site_laura)
}
