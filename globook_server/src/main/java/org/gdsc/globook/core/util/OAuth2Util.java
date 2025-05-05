package org.gdsc.globook.core.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.response.OAuth2UserInfo;
import org.gdsc.globook.core.constant.Constants;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

@Component
@Slf4j
public class OAuth2Util {
    private final RestClient restClient = RestClient.builder().build();

    public OAuth2UserInfo getGoogleOAuth2UserInfo(String accessToken) {
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add(Constants.AUTHORIZATION_HEADER, Constants.BEARER_PREFIX + accessToken);
        httpHeaders.add(Constants.CONTENT_TYPE, Constants.APPLICATION_FORM_URLENCODED_WITH_CHARSET);

        try {
            String response = restClient.method(HttpMethod.POST)
                    .uri(Constants.GOOGLE_RESOURCE_SERVER_URL)
                    .headers(headers -> headers.addAll(httpHeaders))
                    .retrieve()
                    .body(String.class);

            if (response == null || response.isEmpty()) {
                throw new CustomException(GlobalErrorCode.OAUTH2_USER_INFO_REQUEST_FAILED);
            }

            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode node = objectMapper.readTree(response);

            return OAuth2UserInfo.of(
                    node.get(Constants.GOOGLE_SOCIAL_ID_FIELD).asText(),
                    node.get(Constants.USER_EMAIL_CLAIM_NAME).asText()
            );

        } catch (RestClientException e) {
            log.error("Google 유저 정보 요청 중 RestClient 오류 발생: {}", e.getMessage(), e);
            throw new RuntimeException("Google 유저 정보 요청 중 RestClient 오류 발생: " + e.getMessage(), e);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }
}
