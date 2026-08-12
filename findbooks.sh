#!/bin/bash
KEYWORD="Nietzsche"

BOLLING=$(printf -- "------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="uuid"\r\n\r\n84d073-cc88-3bfc-a1aa-86be480432d0\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="session_id"\r\n\r\nOVqQnoFN9o9KNI_4LL3_xuEEsHTu\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="log_url"\r\n\r\n/browse/filter/t/%s/k/keyword\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="store_id"\r\n\r\n102\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="b"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="s"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="n"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="d"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="f"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="a"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="o"\r\n\r\n0\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="l"\r\n\r\n26\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="t"\r\n\r\n"%s"\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="k"\r\n\r\n"keyword"\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="v"\r\n\r\n""\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="x"\r\n\r\n""\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="r"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="c"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="g"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H\r\nContent-Disposition: form-data; name="j"\r\n\r\n[]\r\n------WebKitFormBoundary2LF3QcRoFzlgL03H--\r\n" $KEYWORD $KEYWORD)

curl 'https://api.bookmanager.com/customer/browse/get' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryxzZ6XcuQHesROBXL' \
  -H 'DNT: 1' \
  -H 'Origin: https://bolenbooks.com' \
  -H 'Referer: https://bolenbooks.com/' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: cross-site' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/6.8.2 Chrome/122.0.6261.171 Safari/537.36' \
  -H 'sec-ch-ua: "Not(A:Brand";v="24", "Chromium";v="122"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Linux"' \
  --data-raw $'------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="uuid"\r\n\r\n445e4a0-dbc-dd64-1f41-02e13432eed\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="session_id"\r\n\r\n69GEw-pR-fT2KkR9I3VhG7deXTk0\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="log_url"\r\n\r\n/browse/filter/t/fred/k/keyword\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="store_id"\r\n\r\n102\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="b"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="s"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="n"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="d"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="f"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="a"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="o"\r\n\r\n0\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="l"\r\n\r\n26\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="t"\r\n\r\n"fred"\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="k"\r\n\r\n"keyword"\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="v"\r\n\r\n""\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="x"\r\n\r\n""\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="r"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="c"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="g"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL\r\nContent-Disposition: form-data; name="j"\r\n\r\n[]\r\n------WebKitFormBoundaryxzZ6XcuQHesROBXL--\r\n'

RUSSELL=$(printf 'https://www.russellbooks.com/?s=%s' $KEYWORD)

curl 'https://api.bookmanager.com/customer/browse/get' \
	-s \
	-H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundary2LF3QcRoFzlgL03H' \
	--data-raw $"$BOLLING" | jq "[ .rows[] | { author: .authors , title: .title } ]"

curl "$RUSSELL" -s |
    grep -Po "a href=.*\K(author=|title=\").*\"" | sed -e 's/%2C+/ /g' -e 's/author=/author="/g'
