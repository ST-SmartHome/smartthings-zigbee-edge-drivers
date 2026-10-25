# Catalog 입력

Family Lua·profile·capability resource를 연결하는 빌드 입력과 생성 계획을 관리한다.
기기 동작은 `source/src/contracts/families/`, 서버 resource는 `custom-capabilities/`에서 소유한다.

| 파일·폴더 | 역할·갱신 방법 |
| --- | --- |
| `custom_capabilities/` | Family별 runtime metadata의 편집 입력. [형식과 생성기](custom_capabilities/README.md)를 따른다. |
| `family_registration_extensions.json` | Catalog ID·require/alias·동적 참조의 빌드 검증 입력. 해당 family 구현과 일치시킨다. |
| `zcl_reporting_capabilities.json` | 보고 설정의 family·논리 채널·profile 연결 계획. `custom-capabilities/scripts/author_zcl_reporting.py`가 생성한다. |

연결 관계는 다음과 같다.

```text
Family Lua + base profile
  -> ZCL 보고 설정 작성기 -> 보고 계획 + rpt-* profile + family binding
Custom capability catalog JSON
  -> generate_custom_capability_catalog.py -> generated/custom_capabilities/families.lua
Package manifest + 승인된 owner 규칙
  -> Package 생성기 -> generated/packages/ + package_registry.lua + ownership artifact
```

`generated/` 경로는 `source/src/` 기준이다. Runtime metadata는
`runtime/capability_metadata.lua`가 읽고 `runtime/capability_binding.lua`가 handler에 연결한다.
Metadata의 `mapping_name`은 같은 family의 실제 writer와 일치해야 한다.

명령과 갱신 순서는 [개발 가이드](../../docs/development_guide.md),
전체 원본·생성물 대응은 [프로젝트 구조](../../docs/workspace_structure.md#원본과-생성물)를 따른다.
