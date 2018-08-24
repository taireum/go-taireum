/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package tai

import (
	"encoding/json"
	"io/ioutil"
	"github.com/ethereum/go-ethereum/log"
	"github.com/ethereum/go-ethereum/p2p/discover"
	"net/http"
)

// check if a given node is permissioned to connect to the change
func IsP2pNodePermissioned(nodename string, currentNode string, datadir string, direction string) bool {
	permissionedList := getP2pPermissionedNodes()

	log.Debug("IsP2pNodePermissioned", "permissionedList", permissionedList)
	for _, v := range permissionedList {
		if v == nodename {
			log.Debug("IsP2pNodePermissioned success.", "connection", direction, "nodename", nodename[:EnodeNameLength], "ALLOWED-BY", currentNode[:EnodeNameLength])
			return true
		}
	}
	log.Debug("IsP2pNodePermissioned failed", "connection", direction, "nodename", nodename[:EnodeNameLength], "DENIED-BY", currentNode[:EnodeNameLength])
	return false
}

// todo: add cache support
func getP2pPermissionedNodes() []string {
	var permissionedList []string
	nodes := parseP2pPermissionedNodes()
	for _, v := range nodes {
		permissionedList = append(permissionedList, v.ID.String())
	}
	return permissionedList
}

func parseP2pPermissionedNodes() []*discover.Node {
	resp, err := http.Get(EnodeUrlConfig)
	if err != nil {
		log.Error("CCC Network is unavailable", "err", err)
		return nil
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Error("CCC Failed to load nodes", "err", err)
		return nil
	}

	nodeList := []string{}
	if err := json.Unmarshal(body, &nodeList); err != nil {
		log.Error("parsePermissionedNodes: Failed to load nodes", "err", err)
		return nil
	}
	// Interpret the list as a discovery node array
	var nodes []*discover.Node
	for _, url := range nodeList {
		if url == "" {
			log.Error("parsePermissionedNodes: Node URL blank")
			continue
		}
		node, err := discover.ParseNode(url)
		if err != nil {
			log.Error("parsePermissionedNodes: Node URL", "url", url, "err", err)
			continue
		}
		//log.Error("json node:   "+node.String())
		nodes = append(nodes, node)
	}
	return nodes
}

// check if a given node is permissioned to connect to the change
func IsRpcPermissioned(ipAddr string) bool {
	permissionedList := getRpcPermissionedIps()

	log.Debug("IsRpcPermissioned", "permissionedList", permissionedList)
	for _, v := range permissionedList {
		if v == ipAddr {
			log.Debug("IsRpcPermissioned success", "ipAddr", ipAddr)
			return true
		}
	}
	log.Debug("IsP2pNodePermissioned failed.", "ipAddr", ipAddr)
	return false
}

// todo: add cache support
func getRpcPermissionedIps() []string {
	resp, err := http.Get(RpcUrlConfig)
	if err != nil {
		log.Error("CCC Network is unavailable", "err", err)
		return nil
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Error("CCC Failed to load nodes", "err", err)
		return nil
	}

	ipList := []string{}
	if err := json.Unmarshal(body, &ipList); err != nil {
		log.Error("getRpcPermissionedIps: Failed to load ips", "err", err)
		return nil
	}
	return ipList
}
