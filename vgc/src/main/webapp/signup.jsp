<%@page import="java.security.MessageDigest"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.IOException"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="dbconfig.jsp" %>

<%
    response.setHeader("Access-Control-Allow-Origin", "*");

    String userEmail = request.getParameter("useremail");
    String userId = request.getParameter("userId");
    String userPassword = request.getParameter("userPassword");
    String userName = request.getParameter("userName");
    String userCallname = request.getParameter("userCallname");

    // 입력 데이터 검증
    if (userEmail == null || userId == null || userPassword == null || userName == null || userCallname == null ||
        userEmail.isEmpty() || userId.isEmpty() || userPassword.isEmpty() || userName.isEmpty() || userCallname.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.println("{\"msg\": \"모든 필드를 채워주세요\", \"code\": 400}");
        return;
    }

    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        con = getConnection();

        // 이메일 중복 체크
        String checkEmailSQL = "SELECT COUNT(*) FROM joinup WHERE userEmail = ?";
        stmt = con.prepareStatement(checkEmailSQL);
        stmt.setString(1, userEmail);
        rs = stmt.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("{\"msg\": \"이미 사용중인 이메일입니다\", \"code\": 400}");
            return;
        }
        rs.close();
        stmt.close();

        // 아이디 중복 체크
        String checkIdSQL = "SELECT COUNT(*) FROM joinup WHERE userId = ?";
        stmt = con.prepareStatement(checkIdSQL);
        stmt.setString(1, userId);
        rs = stmt.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("{\"msg\": \"이미 사용중인 아이디입니다\", \"code\": 400}");
            return;
        }
        rs.close();
        stmt.close();

        // 비밀번호 해싱
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(userPassword.getBytes());
        byte[] pwd = md.digest();
        StringBuilder hashedPassword = new StringBuilder();
        for (byte p : pwd) {
            hashedPassword.append(String.format("%02x", p));
        }

        // 회원가입 처리
        String sql = "INSERT INTO joinup (id, userEmail, userId, userPassword, userName, userCallname) VALUES (null, ?, ?, ?, ?, ?)";

        stmt = con.prepareStatement(sql);
        stmt.setString(1, userEmail);
        stmt.setString(2, userId);
        stmt.setString(3, hashedPassword.toString());
        stmt.setString(4, userName);
        stmt.setString(5, userCallname);

        int result = stmt.executeUpdate();

        if (result > 0) {
            out.println("{\"msg\": \"가입완료\", \"code\": 200}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("{\"msg\": \"가입 실패\", \"code\": 500}");
        }

    } catch (SQLException | ClassNotFoundException e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.println("{\"msg\": \"서버 오류\", \"code\": 500}");
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException ignore) {
            ignore.printStackTrace();
        }
    }
%>