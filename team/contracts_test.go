package team_test

import (
	authv1 "github.com/HockeyNights/hockey-shared-contracts/auth/gen/go/v1"
	profilev1 "github.com/HockeyNights/hockey-shared-contracts/profile/gen/go/v1"
	teamv1 "github.com/HockeyNights/hockey-shared-contracts/team/gen/go/v1"
	"google.golang.org/genproto/googleapis/api/annotations"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/reflect/protoreflect"
	"testing"
)

func TestInternalMethodsHaveNoHTTPRoutes(t *testing.T) {
	cases := []struct {
		file    protoreflect.FileDescriptor
		service string
		methods []string
	}{
		{authv1.File_auth_v1_auth_proto, "AuthService", []string{"BatchUserExists"}},
		{profilev1.File_profile_v1_profile_proto, "ProfileService", []string{"BatchGetProfileSummaries"}},
		{teamv1.File_team_v1_team_proto, "TeamService", []string{"CheckTeamAccess", "CheckClubAccess", "GetTeamMembers", "GetClubTeams"}},
	}
	for _, tc := range cases {
		for _, name := range tc.methods {
			t.Run(tc.service+"/"+name, func(t *testing.T) {
				method := tc.file.Services().ByName(protoreflect.Name(tc.service)).Methods().ByName(protoreflect.Name(name))
				if method == nil {
					t.Fatal("missing RPC")
				}
				if proto.HasExtension(method.Options(), annotations.E_Http) {
					t.Fatal("internal RPC exposes HTTP route")
				}
			})
		}
	}
}
