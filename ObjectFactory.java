package com.services;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;

/**
 * This object contains factory methods for each Java content interface and Java
 * element interface generated in the com.services package.
 * <p>
 * An ObjectFactory allows you to programatically construct new instances of the
 * Java representation for XML content. The Java representation of XML content
 * can consist of schema derived interfaces and classes representing the binding
 * of schema type definitions, element declarations and model groups. Factory
 * methods for each of these are provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

	private final static QName _GetRequestResponse_QNAME = new QName(
			"http://webservices.com/", "getRequestResponse");
	private final static QName _GetRequest_QNAME = new QName(
			"http://webservices.com/", "getRequest");
	private final static QName _GetFileResponse_QNAME = new QName(
			"http://webservices.com/", "getFileResponse");
	private final static QName _GetFile_QNAME = new QName(
			"http://webservices.com/", "getFile");

	/**
	 * Create a new ObjectFactory that can be used to create new instances of
	 * schema derived classes for package: com.services
	 * 
	 */
	public ObjectFactory() {
	}

	/**
	 * Create an instance of {@link GetFile }
	 * 
	 */
	public GetFile createGetFile() {
		return new GetFile();
	}

	/**
	 * Create an instance of {@link GetRequest }
	 * 
	 */
	public GetRequest createGetRequest() {
		return new GetRequest();
	}

	/**
	 * Create an instance of {@link GetRequestResponse }
	 * 
	 */
	public GetRequestResponse createGetRequestResponse() {
		return new GetRequestResponse();
	}

	/**
	 * Create an instance of {@link GetFileResponse }
	 * 
	 */
	public GetFileResponse createGetFileResponse() {
		return new GetFileResponse();
	}

	/**
	 * Create an instance of {@link JAXBElement }{@code <}
	 * {@link GetRequestResponse }{@code >}
	 * 
	 */
	@XmlElementDecl(namespace = "http://webservices.com/", name = "getRequestResponse")
	public JAXBElement<GetRequestResponse> createGetRequestResponse(
			GetRequestResponse value) {
		return new JAXBElement<GetRequestResponse>(_GetRequestResponse_QNAME,
				GetRequestResponse.class, null, value);
	}

	/**
	 * Create an instance of {@link JAXBElement }{@code <}{@link GetRequest }
	 * {@code >}
	 * 
	 */
	@XmlElementDecl(namespace = "http://webservices.com/", name = "getRequest")
	public JAXBElement<GetRequest> createGetRequest(GetRequest value) {
		return new JAXBElement<GetRequest>(_GetRequest_QNAME, GetRequest.class,
				null, value);
	}

	/**
	 * Create an instance of {@link JAXBElement }{@code <}{@link GetFileResponse }
	 * {@code >}
	 * 
	 */
	@XmlElementDecl(namespace = "http://webservices.com/", name = "getFileResponse")
	public JAXBElement<GetFileResponse> createGetFileResponse(
			GetFileResponse value) {
		return new JAXBElement<GetFileResponse>(_GetFileResponse_QNAME,
				GetFileResponse.class, null, value);
	}

	/**
	 * Create an instance of {@link JAXBElement }{@code <}{@link GetFile }{@code
	 * >}
	 * 
	 */
	@XmlElementDecl(namespace = "http://webservices.com/", name = "getFile")
	public JAXBElement<GetFile> createGetFile(GetFile value) {
		return new JAXBElement<GetFile>(_GetFile_QNAME, GetFile.class, null,
				value);
	}

}
