// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Gauge R&R';

  @override
  String get brandSubtitle => '속성 Gauge R&R 검사 시스템';

  @override
  String get actionRetry => '다시 시도';

  @override
  String get actionOk => '확인';

  @override
  String get loginTitle => '로그인';

  @override
  String get loginSubtitle => '사원 코드와 비밀번호를 입력하세요.';

  @override
  String get employeeCodeLabel => '사원 코드';

  @override
  String get employeeCodePlaceholder => '예: EMP-0001';

  @override
  String get employeeCodeRequired => '사원 코드를 입력해야 합니다.';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get passwordPlaceholder => '비밀번호를 입력하세요';

  @override
  String get passwordRequired => '비밀번호를 입력해야 합니다.';

  @override
  String get signInAction => '로그인';

  @override
  String get noAccountPrompt => '계정이 없으신가요?';

  @override
  String get registerAction => '회원가입';

  @override
  String get viewComponentsAction => 'UI 컴포넌트 보기';

  @override
  String get settingsAction => '설정';

  @override
  String get registerPageTitle => '계정 만들기';

  @override
  String get registerHeadline => '검사원 계정 만들기';

  @override
  String get registerSubtitle => '회원가입은 항상 승인 대기 상태의 검사원 계정을 만듭니다.';

  @override
  String get fullNameLabel => '이름';

  @override
  String get fullNamePlaceholder => '회사 기록과 동일한 이름';

  @override
  String get fullNameRequired => '이름을 입력해야 합니다.';

  @override
  String get emailOptionalLabel => '이메일 (선택)';

  @override
  String get emailPlaceholder => 'name@company.com';

  @override
  String get emailInvalid => '이메일 형식이 올바르지 않습니다.';

  @override
  String get confirmPasswordLabel => '비밀번호 확인';

  @override
  String get confirmPasswordPlaceholder => '비밀번호를 다시 입력하세요';

  @override
  String get passwordMismatch => '비밀번호 확인이 일치하지 않습니다.';

  @override
  String get submitRegistrationAction => '가입 신청';

  @override
  String get registrationSuccessTitle => '요청 접수됨';

  @override
  String get registrationSuccessMessage =>
      '감사합니다. 제출한 정보가 요건을 충족하면 관리자가 검토합니다. 자세한 내용은 관리자에게 문의하세요.';

  @override
  String get dashboardWelcome => '환영합니다';

  @override
  String get dashboardLogout => '로그아웃';

  @override
  String get dashboardSummaryTitle => '검사 요약';

  @override
  String get dashboardSummaryBody =>
      '평가 지표, 검사 세션, 보고서는 API 계약이 준비되면 여기에 표시됩니다. 모든 계산은 Laravel 백엔드에서 수행됩니다.';

  @override
  String get unknownUser => '사용자';

  @override
  String get unknownValue => '-';

  @override
  String get roleUnknown => '알 수 없는 역할';

  @override
  String get roleAdmin => '관리자';

  @override
  String get roleManager => '매니저';

  @override
  String get roleInspector => '검사원';

  @override
  String get statusPending => '대기 중';

  @override
  String get statusActive => '활성';

  @override
  String get statusInactive => '비활성';

  @override
  String get verdictGood => '양호';

  @override
  String get verdictDefect => '불량';

  @override
  String get settingsPageTitle => '설정';

  @override
  String get settingsLanguageSection => '언어';

  @override
  String get settingsLanguageDescription => '애플리케이션 인터페이스 언어를 선택하세요.';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English (US)';

  @override
  String get languageKorean => '한국어';

  @override
  String get componentsPageTitle => 'UI 컴포넌트';

  @override
  String get componentsButtonsTitle => '버튼';

  @override
  String get componentsButtonsDescription => '기본 사용법, 변형, 로딩 상태, 비활성 상태입니다.';

  @override
  String get componentsPrimaryAction => '기본 동작';

  @override
  String get componentsTonalVariant => '톤 변형';

  @override
  String get componentsOutlineVariant => '아웃라인 변형';

  @override
  String get componentsTextVariant => '텍스트 변형';

  @override
  String get componentsLoadingIdle => '로딩 상태 보기';

  @override
  String get componentsLoadingBusy => '처리 중…';

  @override
  String get componentsDisabledAction => '동작 없는 비활성 버튼';

  @override
  String get componentsInputsTitle => '텍스트 입력';

  @override
  String get componentsInputsDescription => '레이블, 도움말, 오류, 비밀번호, 비활성 상태입니다.';

  @override
  String get componentsHelperText => '예시용이며 API로 전송되지 않습니다.';

  @override
  String get componentsErrorFieldLabel => '오류가 있는 입력';

  @override
  String get componentsErrorFieldPlaceholder => '내용을 입력해 보세요';

  @override
  String get componentsErrorFieldMessage => '백엔드 검증 메시지 예시입니다.';

  @override
  String get componentsPasswordFieldLabel => '비밀번호';

  @override
  String get componentsDisabledFieldLabel => '비활성 입력';

  @override
  String get componentsDisabledFieldValue => '비활성';

  @override
  String get componentsInteractionTitle => '데스크톱 및 모바일 상호작용';

  @override
  String get componentsInteractionDescription =>
      '탭, 클릭, 키보드 동작을 확인하는 접이식 영역입니다.';

  @override
  String get componentsShowDetails => '세부 정보 보기';

  @override
  String get componentsHideDetails => '세부 정보 숨기기';

  @override
  String get componentsInteractionBody =>
      '이 콘텐츠는 정적 애니메이션이 아니라 실제 상태에서 표시됩니다. Tab으로 포커스를 이동하고 Enter로 버튼을 활성화하세요.';

  @override
  String get errorNetwork => '서버에 연결할 수 없습니다. 연결 상태를 확인하세요.';

  @override
  String get errorTimeout => '서버 응답 시간이 초과되었습니다. 다시 시도하세요.';

  @override
  String get errorUnauthorized => '세션이 만료되었습니다. 다시 로그인하세요.';

  @override
  String get errorForbidden => '이 작업에 대한 권한이 없습니다.';

  @override
  String get errorValidation => '전송한 데이터가 올바르지 않습니다. 입력 내용을 확인하세요.';

  @override
  String get errorNotFound => '요청한 데이터를 찾을 수 없습니다.';

  @override
  String get errorConflict => '요청이 현재 데이터와 충돌합니다.';

  @override
  String get errorServer => '서버에 문제가 발생했습니다. 나중에 다시 시도하세요.';

  @override
  String get errorInvalidResponse => '서버 응답을 인식할 수 없습니다. 문제가 계속되면 관리자에게 문의하세요.';

  @override
  String get errorCancelled => '요청이 취소되었습니다.';

  @override
  String get errorUnknown => '예기치 않은 오류가 발생했습니다. 다시 시도하세요.';

  @override
  String get errorSessionRestoreFailed => '저장된 세션을 읽을 수 없습니다. 다시 로그인하세요.';

  @override
  String get errorSessionStorageFailed => '세션을 기기에 저장할 수 없습니다. 다시 시도하세요.';

  @override
  String get errorSessionClearFailed =>
      '로컬 세션을 완전히 삭제하지 못했습니다. 앱을 종료한 후 다시 로그인하세요.';

  @override
  String get errorUnauthenticated => '세션이 만료되었습니다. 다시 로그인하세요.';

  @override
  String get errorInvalidCredentials => '사원 코드 또는 비밀번호가 올바르지 않습니다.';

  @override
  String get errorAccountPending => '계정이 아직 관리자 승인을 기다리고 있습니다.';

  @override
  String get errorAccountInactive => '계정이 비활성 상태입니다. 관리자에게 문의하세요.';

  @override
  String get errorPasswordChangeRequired => '계속하려면 비밀번호를 변경해야 합니다.';

  @override
  String get errorMethodNotAllowed => '지원되지 않는 요청입니다.';

  @override
  String get errorTooManyRequests => '시도가 너무 많습니다. 잠시 후 다시 시도하세요.';

  @override
  String get errorHttpError => '예기치 않은 오류가 발생했습니다. 다시 시도하세요.';

  @override
  String get companyName => 'PT TKG TAEKWANG INDONESIA';

  @override
  String get digitalGrrSystem => 'Digital Gauge R&R System';

  @override
  String get qualityControlPlatform => 'QUALITY CONTROL PLATFORM';

  @override
  String get heroTitle => 'Measurement you can trust.';

  @override
  String get heroSubtitle => '일관되고 정확하며 감사가 가능한 측정 시스템 평가.';

  @override
  String get welcomeTitle => '환영합니다';

  @override
  String get welcomeSubtitle => '회사 계정으로 로그인하세요.';

  @override
  String get rememberMe => '로그인 상태 유지';

  @override
  String get forgotPassword => '비밀번호 찾기';

  @override
  String get forgotPasswordMessage => '계정 비밀번호를 재설정하려면 회사 시스템 관리자에게 문의해 주십시오.';

  @override
  String get securityBadge => '암호화 및 보호된 사내 전용 시스템';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요?';

  @override
  String get registerHeroSubtitle => '사내 품질 검사 시스템에 참여하세요.';
}
