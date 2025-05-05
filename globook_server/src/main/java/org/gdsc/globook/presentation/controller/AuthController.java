package org.gdsc.globook.presentation.controller;

import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.service.AuthService;
import org.gdsc.globook.core.common.BaseResponse;
import org.gdsc.globook.core.constant.Constants;
import org.gdsc.globook.core.security.info.JwtToken;
import org.gdsc.globook.presentation.request.SignInRequestDto;
import org.gdsc.globook.presentation.request.SignUpRequestDto;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/auth")
@Slf4j
public class AuthController {
    private final AuthService authService;

    @PostMapping("/sign-in/google")
    BaseResponse<JwtToken> googleLogin(
            @NotNull @RequestHeader(Constants.AUTHORIZATION_HEADER) String accessToken
    ) {
        log.info("accssToken: {}", accessToken);
        return BaseResponse.success(authService.googleLogin(accessToken));
    }

    @PostMapping("/sign-in")
    BaseResponse<JwtToken> defaultSignIn(
            @RequestBody SignInRequestDto signInRequestDto
    ) {
        return BaseResponse.success(authService.defaultSignIn(signInRequestDto));
    }

    @PostMapping("/sign-up")
    BaseResponse<JwtToken> signUp(
            @RequestBody SignUpRequestDto signUpRequestDto
    ) {
        return BaseResponse.success(authService.signUp(signUpRequestDto));
    }
}
