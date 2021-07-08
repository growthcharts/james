laura <- system.file("testdata", "Laura_S.json", package = "james")
laura_gro <- system.file("testdata", "Laura_S_gro.json", package = "james")
laura_dev <- system.file("testdata", "Laura_S_dev.json", package = "james")
laura_dev_2 <- system.file("testdata", "Laura_S_dev_2.json", package = "james")

kevin <- system.file("testdata", "Kevin_S.json", package = "james")
kevin_gro <- system.file("testdata", "Kevin_S_gro.json", package = "james")
kevin_dev <- system.file("testdata", "Kevin_S_dev.json", package = "james")

host <- "https://groeidiagrammen.nl"

test_that(
  "creates site_laura, with messages",
  expect_message(site_laura <- request_site(laura, host = host, version = 1))
)

#site_laura_gro <- request_site(laura_gro, host = host, version = 1)
#site_laura_dev <- request_site(laura_dev, host = host, version = 1)
#site_laura_dev_2 <- request_site(laura_dev_2, host = host, version = 1)

test_that(
  "creates site_kevin, with messages",
  expect_message(site_kevin <- request_site(kevin, host = host, version = 1))
)
# site_kevin_gro <- request_site(kevin_gro, host = host, version = 1)
# site_kevin_dev <- request_site(kevin_dev, host = host, version = 1)

# browseURL(site_laura)
