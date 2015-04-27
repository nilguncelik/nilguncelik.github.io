---
title: What happens when you type google.com into your browser and press enter?
author: NC
category: web-development
public: true
---

- The browser decides if it is a URL or a search term.
- The browser checks its "preloaded HSTS (HTTP Strict Transport Security)" list.
	- If the URL is in the list it will make a request with https protocol.
- The browser converts non-ASCII Unicode characters in hostname using Punycode encoding. It represents Unicode with subset of ASCII characters which is supported by Domain Name System (DNS).

### DNS look up and caches
	- The browser checks its cache.
	- The browser asks to OS. Operating systems keep the records in its cache or in `hosts` file.
	- If OS does not have it then a request is made to the known DNS server. This is typically the local router or the ISP's caching DNS server.
	- The local DNS server is looked up.
		- If the DNS server is on the same subnet the ARP (Address Resolution Protocol) cache is checked for an ARP entry for the DNS server. If there is an entry in the ARP cache, we get the information: `DNS.server.ip.address = dns:mac:address`.
			- If there is no entry in the ARP cache we do the ARP process.
			- If the DNS server is on a different subnet, we check the ARP cache for the default gateway IP. If we have an entry in the ARP cache, we get the information: `default.gateway.ip.address = gateway:mac:address`.
			- If there is no entry in the ARP cache we do the ARP process for the default gateway IP.
	- Now that we have the IP address of either our DNS server or the default gateway we can resume our DNS process:
	- Port 53 is opened to send a UDP request to DNS server (if the response size is too large, TCP will be used instead).
	- If the local/ISP DNS server does not have it, then a recursive search is requested and that flows up the list of DNS servers until the SOA is reached, and if found an answer is returned.

### Socket Connection

	- The browser receives the IP address of the destination server it takes that and the given port number from the URL ( 80 or 443 by default) requests a TCP socket stream from OS.
	- This request is passed through Transport, Network and Link Layers and becomes ready to be transmitted through your internet connection.
	- The packet will pass from your computer, possibly through a local network, and then through a modem which converts digital signals into analog signals suitable for transmission over telephone, cable, or wireless telephony connections. On the other end of the connection is another modem which converts the analog signal back into digital data to be processed by the next network node where the from and to addresses would be analyzed further.
		- If your connection is fiber or direct Ethernet the data remains digital and is passed directly to the next network node.
	- Eventually, the packet will reach the router managing the local subnet. From there, it will continue to travel to the AS's border routers, other ASes, and finally to the destination server. Each router along the way extracts the destination address from the IP header and routes it to the appropriate next hop. The TTL field in the IP header is decremented by one for each router that passes. The packet will be dropped if the TTL field reaches zero or if the current router has no space in its queue (perhaps due to network congestion).
	- The server and client will then send and receive multiple messages following the TCP connection flow (ISN, SEQ, FIN packages).
- TLS Handshake
	- If the connection requires TLS, the server and client will make TLS handshake and from now on, the TLS session communicates information encrypted with the agreed key.

### HTTP Request
	- If the browser is Chrome, instead of sending an HTTP request to retrieve the page, it will send a request to try and negotiate with the server an "upgrade" from HTTP to the SPDY protocol.
	- If it is not Chrome, it will send a request of the form:

		```
		GET / HTTP/1.1
		Host: google.com
		Connection: close   // close connection after completion of response.
		[other headers]
		                    // blank newline to indicate content of request is done
		```
	- The server responds with a response code denoting the status of the request

		```
		200 OK
		[response headers]
		```
	- The server may then either close the connection, or if headers sent by the client requested it, keep the connection open to be reused for further requests.
	- If the HTTP headers sent by the web browser included sufficient information for the web server to determine if the version of the file cached by the web browser has been unmodified since the last retrieval (ie. if the web browser included an ETag header), it may have instead responded with a request of the form:

		```
		304 Not Modified
		[response headers]    // no payload, thw browser will than retrieve HTML from its cache.
		```
	- After parsing the HTML, the web browser (and server) will repeat this process for every resource (image, CSS, favicon.ico, etc) referenced by the HTML page:

		```
		GET /$(relative URL) HTTP/1.1
		```
	- If the HTML referenced a resource on a different domain than www.google.com, the web browser will go back to the steps involved in resolving the other domain, and follow all steps up to this point for that domain. The Host header in the request will be set to the appropriate server name instead of google.com.

- The server ( HTTP Deamon, for ex. Apache, IIS)
	- The server breaks down the request to the following parameters:
		- HTTP Request Method (GET, POST, HEAD, PUT and DELETE) - GET.
		- Domain - google.com.
		- Requested path/page - /
	- The server verifies that there is a Virtual Host configured on the server that corresponds with google.com.
	- The server verifies that google.com can accept GET requests.
	- The server verifies that the client is allowed to use this method (by IP, authentication, etc.).
	- If the server has a rewrite module installed (like mod_rewrite for Apache or URL Rewrite for IIS), it tries to match the request against one of the configured rules. If a matching rule is found, the server uses that rule to rewrite the request.
	- The server goes to pull the content that corresponds with the request.
	- The server will parse the file according to the handler, for example - let's say that Google is running on PHP.
		- The server will use PHP to interpret the index file, and catch the output.
		- The server will return the output, on the same request to the client.

### The Browser

- The browser then parse DOM and CSSOM from the html and build render tree, calculate layout and paint pixels on the screen.
- Minimize eliminate render blocking resources (css, font, unknown size images, js).


**References**

- <https://github.com/alex/what-happens-when>
- TR - <http://www.moserware.com/2009/06/first-few-milliseconds-of-https.html>
