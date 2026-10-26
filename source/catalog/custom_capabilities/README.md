# Family Custom-Capability Catalog

Family별 runtime metadata의 편집 원본이다. 서버 schema·presentation·번역은
`custom-capabilities/capabilities/<ID>/current/`에서 관리한다.

| 입력 | 행 형식 |
| --- | --- |
| `attribute_overrides.json` | `[capabilityId, attributeName]` |
| `numeric.json` | `[capabilityId, writable, mappingName, minimum, maximum, step, unit]` |
| `enum.json` | `[capabilityId, writable, mappingName, supportedValues]` |
| `text.json` | `[capabilityId, writable, mappingName, maximumLength]` |

`manifest.json`은 namespace·format version·행 수를 고정한다. 배열 순서는 package별 metadata
선택과 runtime 등록 순서에 쓰이므로 유지한다. `mappingName`은 같은 family의 실제 writer 이름이다.

숫자 행의 `null`은 의도적인 범위·step·unit 생략이다. 생성된 빈 `default_range` table을
`nil`로 바꾸지 않는다. Enum 행의 values table도 해당 행의 `supported_values`와
`default_range.allowed_values`가 공유하는 관계를 유지한다.

Workspace 루트에서 재생성·확인한다.

```powershell
python source\tools\generate_custom_capability_catalog.py --jobs 4
python source\tools\generate_custom_capability_catalog.py --check --jobs 4
python source\tools\test_generated_custom_capability_catalog.py
```

생성기는 `source/src/generated/custom_capabilities/families.lua`를 작성한다.
`source/src/runtime/capability_metadata.lua`가 이 모듈을 직접 읽고,
`source/src/runtime/capability_binding.lua`가 emit·command 경로를 연결한다.
퇴역한 `core/family_custom_capabilities.lua` shim을 다시 만들지 않는다.

`analysis/custom_capability_family_matrix.json`은 과거 분석 입력이다.
현재 runtime catalog를 이 파일에서 재생성하지 않는다.
