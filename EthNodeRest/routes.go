package main

import "net/http"

type Route struct {
	Name        string
	Method      string
	Pattern     string
	HandlerFunc http.HandlerFunc
}

type Routes []Route

var routes = Routes{
	Route{
		"Index",
		"GET",
		"/",
		Index,
	},
	Route{
		"N1",
		"GET",
		"/n1",
		N1,
	},
	Route{
		"N2",
		"GET",
		"/n2",
		N2,
	},
}
