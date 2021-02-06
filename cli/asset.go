package cli

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
)

// Asset is a build for a particular system, uploaded to a GitHub release.
type Asset struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	ContentType string `json:"content_type"`
}

func (a *Asset) download() (*bytes.Reader, error) {
	downloadURL := fmt.Sprintf("%s/assets/%d", ReleaseURL, a.ID)

	req, err := http.NewRequest("GET", downloadURL, nil)
	if err != nil {
		return nil, err
	}

	req.Header.Set("Accept", "application/octet-stream")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}

	defer res.Body.Close()

	bs, err := ioutil.ReadAll(res.Body)
	if err != nil {
		return nil, err
	}

	return bytes.NewReader(bs), nil
}
