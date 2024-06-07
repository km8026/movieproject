<%@page import="java.security.MessageDigest"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="application/json; charset=utf-8" pageEncoding="utf-8"%>
<%

response.setHeader("Access-Control-Allow-Origin", "*");

String userId = request.getParameter("id");
String userPassword = request.getParameter("pw");

MessageDigest md = MessageDigest.getInstance("SHA-256");
md.update(userPassword.getBytes());
byte[] pwd = md.digest();
StringBuilder sb = new StringBuilder();
for (byte b : pwd) {
    sb.append(String.format("%02x", b));
}
String hashedPassword = sb.toString();

String DRIVER_CLASS_NAME = "org.mariadb.jdbc.Driver";
String URL = "jdbc:mariadb://localhost:3306/vgc";
String USERNAME = "root";
String PASSWORD = "1234";

Class.forName(DRIVER_CLASS_NAME);
Connection con = DriverManager.getConnection(URL, USERNAME, PASSWORD);

String sql = "SELECT userPassword FROM joinup WHERE userId = ?";
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setString(1, userId);
ResultSet rs = stmt.executeQuery();

Map<String, Object> map = new HashMap<>();
int code = 0;
String msg = "";

if (rs.next()) {
    String dbPw = rs.getString("userPassword");
    if (hashedPassword.equals(dbPw)) {
        session.setAttribute("userId", userId); // 세션에 사용자 ID 저장
        code = 0;
        msg = "로그인 되었습니다!";
    } else {
        code = 1;
        msg = "비밀번호를 확인해주세요.";
    }
} else {
    code = 2;
    msg = "아이디를 확인해주세요.";
}

ObjectMapper om = new ObjectMapper();
map.put("code", code);
map.put("msg", msg);

rs.close();
stmt.close();
con.close();

response.setContentType("application/json; charset=UTF-8");
out.println(om.writeValueAsString(map));

%>
