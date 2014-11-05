local INT, STRING, FLOAT  = 
	wrench.META_TYPE_INT,
	wrench.META_TYPE_STRING,
	wrench.META_TYPE_FLOAT

wrench:register_node("bitchange:warehouse", {
	lists = {"main", "main2", "worksp"},
	metas = {
		owner = STRING,
		infotext = STRING
	},
	owned = true,
})

wrench:register_node("bitchange:moneychanger", {
	lists = {"source", "rest", "output"},
	metas = {
		owner = STRING,
		infotext = STRING
	},
	owned = true,
})

wrench:register_node("bitchange:toolrepair", {
	lists = {"src", "fuel"},
	metas = {
		owner = STRING,
		infotext = STRING,
		state = INT
	},
	owned = true,
})

wrench:register_node("bitchange:shop", {
	lists = {"stock", "custm", "custm_ej", "cust_ow", "cust_og", "cust_ej"},
	metas = {
		owner = STRING,
		infotext = STRING,
		title = STRING
	},
	owned = true,
})