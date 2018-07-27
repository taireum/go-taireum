package tai

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/params"
	"bytes"
	"github.com/ethereum/go-ethereum/tai"
)

var (
	authoritiesUrl = "http://localhost:8421/authorities"
	contractUrl    = "http://localhost:8421/contrac"
)

type Authority struct {
}

func newAuthority(config *params.TaiConfig) *Authority {

	return &Authority{}
}

//get authority address from ccc
func (a *Authority) Signers() map[common.Address]struct{} {
	s := make(map[common.Address]struct{})
	authorityAddresses := tai.ListFromUrl(authoritiesUrl)
	if (authorityAddresses != nil) {
		for _, authorityAddress := range authorityAddresses {
			s[common.HexToAddress(authorityAddress)] = struct{}{}
		}
	}
	return s
}

// get vote contract address from ccc
// the function is called onle once for whole blockchain only in founder node
func (a *Authority) contractAddress() common.Address {
	contractAddresses := tai.ListFromUrl(contractUrl)
	if (contractAddresses != nil && len(contractAddresses) > 1) {
		return common.HexToAddress(contractAddresses[0])
	}
	return common.Address{}
}

// signers retrieves the list of authorized signers in ascending order.
func (a *Authority) signers() []common.Address {
	signers := make([]common.Address, 0, len(a.Signers()))
	for signer := range a.Signers() {
		signers = append(signers, signer)
	}
	for i := 0; i < len(signers); i++ {
		for j := i + 1; j < len(signers); j++ {
			if bytes.Compare(signers[i][:], signers[j][:]) > 0 {
				signers[i], signers[j] = signers[j], signers[i]
			}
		}
	}
	return signers
}

// hostturn returns if a signer at a given block height is host or guest.
//TODO what happend when add a new singer. snapshot？ no
func (a *Authority) hostturn(number uint64, signer common.Address) bool {
	signers, offset := a.signers(), 0
	for offset < len(signers) && signers[offset] != signer {
		offset++
	}
	return (number % uint64(len(signers))) == uint64(offset)
}
