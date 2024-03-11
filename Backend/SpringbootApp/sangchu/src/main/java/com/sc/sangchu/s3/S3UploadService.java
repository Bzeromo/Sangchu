package com.sc.sangchu.s3;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.sc.sangchu.dto.FileUploadDTO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;
import javax.imageio.ImageIO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@RequiredArgsConstructor
public class S3UploadService {

    private final AmazonS3Client amazonS3Client;

    @Value("${spring.cloud.aws.s3.bucket}")
    private String bucket;

    public String saveThumbnailImage(MultipartFile multipartFile) throws IOException {
        String originalFilename = multipartFile.getOriginalFilename();
        String filenameWithPath = "thumbnailImage/" + originalFilename;

        try (InputStream inputStream = multipartFile.getInputStream()) {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(multipartFile.getSize());
            metadata.setContentType(multipartFile.getContentType());

            amazonS3Client.putObject(bucket, filenameWithPath, inputStream, metadata);
            return amazonS3Client.getUrl(bucket, filenameWithPath).toString();
        }
    }

    public String saveProfileImage(MultipartFile multipartFile, String userEmail) throws IOException {
        String filenameWithPath = "profileImage/" + userEmail;

        try (InputStream inputStream = multipartFile.getInputStream()) {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(multipartFile.getSize());
            metadata.setContentType(multipartFile.getContentType());

            amazonS3Client.putObject(bucket, filenameWithPath, inputStream, metadata);
            return amazonS3Client.getUrl(bucket, filenameWithPath).toString();
        }
    }

//    public String saveImage(FileUploadDTO fileUploadDTO) throws IOException {
//        String filenameWithPath = fileUploadDTO.getType() +"/"+ fileUploadDTO.getImageName();
//        byte[] decodedImg = Base64.getDecoder().decode(fileUploadDTO.getImageBase64().split(",")[1]);
//        ByteArrayInputStream inputStream = new ByteArrayInputStream(decodedImg);
//
//        ObjectMetadata metadata = new ObjectMetadata();
//        metadata.setContentLength(decodedImg.length);
//        // Base64 인코딩 문자열의 MIME 타입을 추출하여 설정합니다.
//        // "data:image/png;base64," 등의 접두사를 가진 경우에만 필요합니다.
//        String mimeType = fileUploadDTO.getImageBase64().split(";")[0].split(":")[1];
//        metadata.setContentType(mimeType);
//
//        amazonS3Client.putObject(bucket, filenameWithPath, inputStream, metadata);
//
//        return amazonS3Client.getUrl(bucket, filenameWithPath).toString();
//    }
}
