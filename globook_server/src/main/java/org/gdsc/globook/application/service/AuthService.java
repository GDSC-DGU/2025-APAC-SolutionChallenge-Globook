package org.gdsc.globook.application.service;

import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.repository.UserRepository;
import org.gdsc.globook.application.response.OAuth2UserInfo;
import org.gdsc.globook.core.constant.Constants;
import org.gdsc.globook.core.exception.CustomException;
import org.gdsc.globook.core.exception.GlobalErrorCode;
import org.gdsc.globook.core.security.info.JwtToken;
import org.gdsc.globook.core.util.JwtUtil;
import org.gdsc.globook.core.util.OAuth2Util;
import org.gdsc.globook.core.util.RandomNicknameUtil;
import org.gdsc.globook.core.util.RandomPasswordUtil;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.ELoginProvider;
import org.gdsc.globook.domain.type.EUserRole;
import org.gdsc.globook.domain.entity.User;
import org.gdsc.globook.presentation.request.SignInRequestDto;
import org.gdsc.globook.presentation.request.SignUpRequestDto;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {
    private final UserRepository userRepository;
    private final OAuth2Util oAuth2Util;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    // 구글 로그인
    @Transactional
    public JwtToken googleLogin(String accessToken) {
        String refinedToken = refineToken(accessToken);
        OAuth2UserInfo oAuth2UserInfoDto = oAuth2Util.getGoogleOAuth2UserInfo(refinedToken);
        return processSocialLogin(oAuth2UserInfoDto);
    }

    // 회원가입
    @Transactional
    public JwtToken signUp(SignUpRequestDto signUpRequestDto) {
        Optional<User> user = userRepository.findByEmail(signUpRequestDto.email());
        if (user.isPresent()) {
            throw new CustomException(GlobalErrorCode.ALREADY_EXISTS);
        }

        if (!signUpRequestDto.password().equals(signUpRequestDto.passwordConfirm())) {
            throw new CustomException(GlobalErrorCode.VALIDATION_ERROR);
        }

        User newUser = User.create(
                signUpRequestDto.email(),
                bCryptPasswordEncoder.encode(signUpRequestDto.password()),
                RandomNicknameUtil.generateRandomNickname(),
                ELoginProvider.DEFAULT
        );

        userRepository.save(newUser);
        return jwtUtil.generateToken(newUser.getId(), EUserRole.USER);
    }

    // 일반 로그인
    @Transactional
    public JwtToken defaultSignIn(SignInRequestDto signInRequestDto) {
        User user = userRepository.findByEmail(signInRequestDto.email())
                .orElseThrow(() -> new CustomException(GlobalErrorCode.NOT_FOUND_USER));
        if (!bCryptPasswordEncoder.matches(signInRequestDto.password(), user.getPassword())) {
            throw new CustomException(GlobalErrorCode.NOT_FOUND_USER);
        }

        return jwtUtil.generateToken(user.getId(), EUserRole.USER);
    }

    // 유저 없으면 DB에 저장하고 토큰 반환, 없으면 바로 반환
    private JwtToken processSocialLogin(OAuth2UserInfo oAuth2UserInfo) {
        String email = oAuth2UserInfo.email();
        User user = userRepository.findByEmail(email)
                .orElseGet(() -> {
                    User newUser = User.create(
                            oAuth2UserInfo.email(),
                            bCryptPasswordEncoder.encode(RandomPasswordUtil.generateRandomPassword()),
                            RandomNicknameUtil.generateRandomNickname(),
                            ELoginProvider.GOOGLE
                    );
                    return userRepository.save(newUser);
                });

        return jwtUtil.generateToken(user.getId(), EUserRole.USER);
    }

    private String refineToken(String accessToken) {
        return accessToken.startsWith(Constants.BEARER_PREFIX)
                ? accessToken.substring(Constants.BEARER_PREFIX.length())
                : accessToken;
    }
}
