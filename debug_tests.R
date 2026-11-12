txt_p <- "C:/Users/eekhouti/OneDrive - TNO/TNO - CH - Partou GSED D-score/request_body-15012026.json"

james::dcat(txt = txt_p, p = 50)

james::calculate_ddomain(txt = txt_p, format = "3.1")


james:::get_tgt(txt_p, append = "gs1")

library(dscore)

ddomain(data = data.frame(age = 0.690, gs1lgc004 = 1))

ddomain(data = data.frame(age = 0.690, gs1cgc032 = NA, gs1lgc004 = 1))


#als alles missing is dan geeft hij geen leeftijd?
dscore( data.frame(age = 0.690, gs1lgc004 = 1))
dscore( data.frame(age = 0.690, gs1cgc032 = NA, gs1lgc004 = 1))
dscore( data.frame(age = 0.690, gs1lgc004 = 1, gs1cgc032 = NA))
dscore( data.frame(age = 0.690, gs1cgc032 = 1, gs1lgc004 = NA))
dscore( data.frame(age = 0.690, gs1lgc004 = NA, gs1cgc032 = 1))
dscore( data.frame(age = 0.690, gs1cgc032 = 1, gs1lgc004 = 1))

dscore(data.frame(age = 0.690, gs1cgc032 = NA, gs1moc008 = NA, gs1sec001 = NA, gs1moc002 = NA, gs1sec003 = NA, gs1lgc004 = 0, gs1moc005 = 0))

builtin_domaintable |> filter(item == "gs1moc005")
builtin_domaintable |> filter(item == "gs1lgc004")

ddomain(data.frame(age = 0.690, gs1cgc032 = NA, gs1moc008 = NA, gs1sec001 = NA, gs1moc002 = NA, gs1sec003 = NA, gs1lgc004 = 0, gs1moc005 = 0))
ddomain(data.frame(age = 0.690, gs1lgc004 = 0, gs1moc005 = 0))

dscore( data.frame(age = 0.690, gs1lgc004 = NA, gs1cgc032 = 1))
dscore( data.frame(age = 0.690, gs1lgc004 = 1, gs1cgc032 = NA))
dscore( data.frame(age = 0.690, gs1lgc004 = 1))

dscore( data.frame(age = 0.690))
