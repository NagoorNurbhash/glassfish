<%--

    Copyright (c) 1997, 2018 Oracle and/or its affiliates. All rights reserved.

    This program and the accompanying materials are made available under the
    terms of the Eclipse Public License v. 2.0, which is available at
    http://www.eclipse.org/legal/epl-2.0.

    This Source Code may also be made available under the following Secondary
    Licenses when the conditions for such availability set forth in the
    Eclipse Public License v. 2.0 are satisfied: GNU General Public License,
    version 2 with the GNU Classpath Exception, which is available at
    https://www.gnu.org/software/classpath/license.html.

    SPDX-License-Identifier: EPL-2.0 OR GPL-2.0 WITH Classpath-exception-2.0

--%>

<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<TITLE>request#getInputStream test.</TITLE>
</HEAD>
<BODY>
readLine.jsp is called.
<HR>

<%
            String expected = (String) session.getAttribute("expected");
            String formName = (String) session.getAttribute("formName");
            request.setCharacterEncoding("UTF-8");
            response.setContentType("text/html; charset=UTF-8");
            int contentLength = request.getContentLength();
            ByteArrayOutputStream baos = new ByteArrayOutputStream(contentLength);
            InputStream is = request.getInputStream();

            readInputStream(is, baos, contentLength);

            //outln(out,sb.toString());
            
            String boundary = null;
            String contentType = request.getContentType();
            if(contentType != null){
                int delim = contentType.indexOf("boundary=");
                boundary = contentType.substring(delim+9).trim();
                int semi = boundary.indexOf(';');
                if (semi != -1) {
                    boundary = boundary.substring(0, semi);
                }

            }
            expected = "--"+boundary+"\r\nContent-Disposition: form-data; name=\""+formName+"\"\r\n\r\n"+expected+"\r\n--"+boundary+"--\r\n";
            
            outln(out, "Content-Type:" + request.getContentType());
            outln(out, "Character Encoding:" + request.getCharacterEncoding());
            outln(out, "Content-Length:" + request.getContentLength());
            outln(out, "expected:" + expected.length());
            outln(out, "real byte read:" + baos.size());
            outln(out, "isSame:" + (baos.toString("UTF-8").equals(expected)));
%>

</BODY>
</HTML>
<%!void readInputStream(InputStream is, ByteArrayOutputStream baos, int contentLength) throws IOException {
        int bytesRead = -1;
        byte[] bytes = new byte[contentLength];
        while ((bytesRead = is.read(bytes, 0, contentLength)) != -1) {
            baos.write(bytes, 0, bytesRead);
        }
    }

    void outln(JspWriter out, String str) throws IOException {
        out.println(str + "<BR>");
        System.out.println(str);
    }%>
