package com.bkty.utils;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class FileUploadUtil {

  public static Map<String, String> uploadFile(HttpServletRequest request, String uploadPath) {
    Map<String, String> params = new HashMap<>();

    try {
      // 创建文件项目工厂
      DiskFileItemFactory factory = new DiskFileItemFactory();
      // 创建文件上传处理器
      ServletFileUpload upload = new ServletFileUpload(factory);
      // 设置上传文件的大小限制为10M
      upload.setSizeMax(10 * 1024 * 1024);

      // 解析请求
      List<FileItem> items = upload.parseRequest(request);

      for (FileItem item : items) {
        if (item.isFormField()) {
          // 处理普通表单字段
          String name = item.getFieldName();
          String value = item.getString("UTF-8");
          params.put(name, value);
        } else {
          // 处理上传文件
          String fileName = item.getName();
          if (fileName != null && !fileName.isEmpty()) {
            // 生成唯一的文件名
            String fileExt = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = UUID.randomUUID().toString() + fileExt;

            // 确保上传目录存在
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
              uploadDir.mkdirs();
            }

            // 保存文件
            File file = new File(uploadPath, newFileName);
            item.write(file);

            // 将文件路径保存到参数map中
            params.put("head", "upload/head/" + newFileName);
          }
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    return params;
  }
}