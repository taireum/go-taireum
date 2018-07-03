package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func Index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Welcome!\n")
}

func N1(w http.ResponseWriter, r *http.Request) {
        x := []string{"enode://3d65bf2b1930bf99a1a1e50d4b3b5eb773ff6e6b5660b76bb6192490e1798cb1e2fbc8464a1e5349cb38bbf444239aa40d52b733d7e9d14799b15df28503d2be@10.200.153.18:30303"}

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(x); err != nil {
		panic(err)
	}
}

func N2(w http.ResponseWriter, r *http.Request) {
        x := []string{"enode://e10a85460e7bf3364ea8b04da77802a3e4edc18116e87d26d5c1fbd033ba6dbe8f6d6b131d969cd020b25ace603e60752ea52f553bb228ee41cca13c3f8814436@[10.200.145.7]:30303","enode://e10a85460e7bf3364ea8b04da77802a3e4edc18116e87d26d5c1fbd033ba6dbe8f6d6b131d969cd020b25ace603e60752ea52f553bb228ee41cca13c3f8814436@[10.200.145.7]:30303"}

        w.Header().Set("Content-Type", "application/json; charset=UTF-8")
        w.WriteHeader(http.StatusOK)
        if err := json.NewEncoder(w).Encode(x); err != nil {
                panic(err)
        
        }
}
