package tai

import(
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/params"
	"bytes"
)

type Authority struct {
	Signers map[common.Address]struct{}
	Url string
}

func newAuthority(config *params.TaiConfig) *Authority{
	s := make(map[common.Address]struct{})

	////TODO signer list should be pull from CCC
	s[common.HexToAddress("0xfcf8fea976c1ffc38e806030045eb76a9652c94a")]=struct{}{}

	authority := &Authority{
		s,
		"",
	}
	return authority
}

// signers retrieves the list of authorized signers in ascending order.
func (a *Authority) signers() []common.Address {
	signers := make([]common.Address, 0, len(a.Signers))
	for signer := range a.Signers {
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