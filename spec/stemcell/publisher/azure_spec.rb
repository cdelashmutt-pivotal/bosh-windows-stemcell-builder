require 'stemcell/publisher/azure'

describe Stemcell::Publisher::Azure do
  let(:response) do
    <<-HEREDOC
{
  "Offer": {
    "VirtualMachineImagesByServicePlan": {
      "2012r2": {
        "OperatingSystemName": "Windows Server 2012R2",
        "OperatingSystemFamily": "windows",
        "RecommendedVmSizes": [
          "d2-standard-v2",
          "d3-standard-v2",
          "d4-standard-v2"
        ],
        "IsLocked": true,
        "PortRules": [],
        "VirtualMachineImages": [
          {
            "VersionId": "1.0.1",
            "VersionLabel": "1.0.1",
            "OsImageUrl": "https://koalapremiumstore.blob.core.windows.net/system/Microsoft.Compute/Images/packer-test/stemcell-osDisk.48d0cb66-bf30-4e0d-8106-774f1fda6fed.vhd?sr=c&sv=2016-05-31&ss=b&srt=co&sp=rl&se=2018-03-20T19:22:16Z&st=2017-03-07T11:22:16Z&spr=https&sig=JWjyPqKjg9cVRUYeeiLpsCyOrvdfIU%2FcTNg7Qg4%2FFNc%3D",
            "IsLocked": true,
            "DataDiskUrlsByLunNumber": {}
          },
          {
            "VersionId": "1.0.3",
            "VersionLabel": "1.0.3",
            "OsImageUrl": "https://devenvdisks477.blob.core.windows.net/system/Microsoft.Compute/Images/boshtest/cfstem-osDisk.f883362e-1c70-491c-abc4-c90a7d0f4dcc.vhd?sr=c&sv=2016-05-31&ss=b&srt=co&sp=rl&se=2018-03-28T23:33:58Z&st=2017-03-14T15:33:58Z&spr=https&sig=l%2Fhu1slbg3x5KooIQUWWJgbeWHDREwJ2hMAnQU6sBD8%3D",
            "IsLocked": true,
            "DataDiskUrlsByLunNumber": {}
          },
          {
            "VersionId": "1.0.4",
            "VersionLabel": "1.0.4",
            "OsImageUrl": "https://koalapremiumstore.blob.core.windows.net/system/Microsoft.Compute/Images/packer-test/stemcell-osDisk.e20b8629-838f-4c4b-b16c-44a3a74992f4.vhd?sr=c&sv=2016-05-31&ss=b&srt=co&sp=rl&se=2018-03-31T22:35:08Z&st=2017-03-17T14:35:08Z&spr=https&sig=6iuIJfm5oGZ8pAzLZSyimAUpUrT%2FEIbxeuPfPiaH7XQ%3D",
            "IsLocked": false,
            "DataDiskUrlsByLunNumber": {}
          }
        ]
      }
    },
    "MarketingDetails": {
      "en-US": {
        "Title": "BOSH Azure Windows Stemcell",
        "Summary": "BOSH Azure Windows Stemcell",
        "LongSummary": "Curabitur mattis odio nec nibh porta elementum.",
        "HtmlDescription": "BOSH Azure Windows Stemcell",
        "ServicePlanMarketingDetails": [
          {
            "ServicePlanNaturalIdentifier": "2012r2",
            "Title": "BOSH Azure Windows Stemcell",
            "Summary": "Cras eget laoreet ex. Vestibulum tincidunt tempus nisl eget condimentum.",
            "Description": "Nunc non nulla risus. Suspendisse potenti. Donec id orci feugiat metus dignissim placerat. Vestibulum placerat, felis eget rutrum interdum, neque ex molestie est, at mollis ante nibh at sapien. Vivamus venenatis dictum magna et bibendum. Fusce dictum nunc leo, vitae vestibulum nisi vehicula vitae. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam et sapien sapien. Phasellus eu ex ac ligula iaculis placerat eu sit amet tellus. Curabitur ut ante sagittis, dictum purus vitae, volutpat mi. Fusce pharetra viverra rhoncus."
          }
        ]
      }
    },
    "Categories": [],
    "ServicePlanDetails": {
      "2012r2": {
        "HideSku": false,
        "WasEverListed": true,
        "CloudTypes": [
          "PublicAzure"
        ]
      }
    }
  },
  "Status": {
    "production": {
      "State": "InProgress",
      "Steps": [
        {
          "PercentCompleted": 100,
          "StartDateTimeOffset": "2017-04-03T13:36:17.4519996+00:00",
          "Failures": [],
          "StepNames": {
            "en-us": "2012r2: AzureCvs - Content validation completed."
          }
        },
        {
          "PercentCompleted": 100,
          "StartDateTimeOffset": "2017-04-03T13:37:35.3991444+00:00",
          "Failures": [],
          "StepNames": {
            "en-us": "2012r2: CertifyVM - Certification completed successfully."
          }
        },
        {
          "PercentCompleted": 0,
          "StartDateTimeOffset": "2017-04-03T13:36:16.6985651+00:00",
          "Failures": [],
          "StepNames": {
            "en-us": "2012r2: ProvisionVM - This step has not started yet."
          }
        },
        {
          "PercentCompleted": 0,
          "StartDateTimeOffset": "2017-04-03T13:36:16.966303+00:00",
          "Failures": [],
          "StepNames": {
            "en-us": "2012r2: PackageVM - This step has not started yet."
          }
        }
      ]
    },
    "staging": {
      "State": "Staged"
    }
  }
}
    HEREDOC
end

let(:sas_response) do
<<-HEREDOC
{
  "sas": "some-sas",
  "url": "https://storageaccount.blob.core.windows.net/containername?some-sas"
}
HEREDOC
end

let(:staging_progress) do
<<-HEREDOC
{
  "staging": {
    "State": "Staged",
    "Steps": [
      {
        "PercentCompleted": 0,
        "StartDateTimeOffset": "2017-04-12T15:19:04.0249287+00:00",
        "Failures": [],
        "StepNames": {
          "en-us": "2012r2: CertifyVM - Certification is in progress."
        }
      },
      {
        "PercentCompleted": 0,
        "StartDateTimeOffset": "2017-04-12T15:19:03.1406153+00:00",
        "Failures": [],
        "StepNames": {
          "en-us": "2012r2: ProvisionVM - This step has not started yet."
        }
      },
      {
        "PercentCompleted": 0,
        "StartDateTimeOffset": "2017-04-12T15:19:03.4844813+00:00",
        "Failures": [],
        "StepNames": {
          "en-us": "2012r2: PackageVM - This step has not started yet."
        }
      }
    ]
  },
  "production": {
    "State": "Listed"
  }
}
HEREDOC
end
let(:production_progress) do
<<-HEREDOC
{
  "staging": {
    "State": "Staged"
  },
  "production": {
    "State": "Listed"
  }
}
HEREDOC
end

let(:finalize_response1){
  '[{ "name": "1.0.1" }, { "name": "1.0.3" }]'
}
let(:finalize_response2){
  '[{ "name": "1.0.1" }, { "name": "1.0.3" }, { "name": "some-version" }]'
}


  describe '#finalize' do
    let (:login_cmd) {
      "azure login --username some-azure-client-id --password some-azure-client-secret "\
      "--service-principal --tenant some-azure-tenant-id --environment AzureCloud"
    }
    before(:each) do
      @publisher = Stemcell::Publisher::Azure.new(sku: 'some-sku',
                                                  azure_client_id: 'some-azure-client-id',
                                                  azure_client_secret: 'some-azure-client-secret',
                                                  azure_tenant_id: 'some-azure-tenant-id',
                                                  version: 'some-version')


      allow(Executor).to receive(:exec_command).with(login_cmd)
      allow_any_instance_of(Object).to receive(:`).
        and_return(finalize_response1, finalize_response2)
      allow_any_instance_of(Object).to receive(:sleep)
    end

    it 'does not print the client secret to stdout or stderr' do
      expect{@publisher.finalize}.
        to_not output(/#{@publisher.azure_client_secret}/).to_stdout
      expect{@publisher.finalize}.
        to_not output(/#{@publisher.azure_client_secret}/).to_stderr
    end

    it 'invokes the Azure CLI' do
      @publisher.finalize

      expect(Executor).to have_received(:exec_command).with(login_cmd)
    end
  end

  describe '#publish' do
    before(:each) do
      api_key = 'some-api-key'

      @publisher = Stemcell::Publisher::Azure.new(api_key: api_key)

      stub_request(:get, @publisher.base_url+'progress').to_return(status: 200, body: staging_progress)
      stub_request(:post, @publisher.base_url+'list').to_return(status: 202)
    end

    it 'does not print the API key to stdout or stderr' do
      allow_any_instance_of(Object).to receive(:sleep)

      expect{@publisher.publish}.
        to_not output(/#{@publisher.api_key}/).to_stdout
      expect{@publisher.publish}.
        to_not output(/#{@publisher.api_key}/).to_stderr
    end

    it 'invokes the Azure publisher API' do
      allow_any_instance_of(Object).to receive(:sleep)

      @publisher.publish

      assert_requested(:get, @publisher.base_url+'progress') do |req|
        headers = req.headers
        (headers['Accept'] == 'application/json') &&
          (headers['Authorization'] ==  "WAMP apikey=#{@publisher.api_key}") &&
        (headers['X-Protocol-Version'] == '2') &&
        (headers['Content-Type'] == 'application/json')
      end
      assert_requested(:post, @publisher.base_url+'list') do |req|
        headers = req.headers
        (headers['Accept'] == 'application/json') &&
          (headers['Authorization'] ==  "WAMP apikey=#{@publisher.api_key}") &&
        (headers['X-Protocol-Version'] == '2') &&
        (headers['Content-Type'] == 'application/json')
      end
    end
  end

  describe '#stage' do
    before(:each) do
      version = 'some-version'
      sku = '2012r2'
      api_key = 'some-api-key'
      azure_storage_account = 'some-azure_storage_account'
      azure_storage_access_key = 'some-azure_storage_access_key'
      azure_tenant_id = 'some-azure-tenant-id'
      azure_client_id = 'some-azure-client-id'
      azure_client_secret = 'some-azure-client-secret'
      container_name = 'some-container-name'
      container_path = 'some-container-path'

      @publisher = Stemcell::Publisher::Azure.new(
        version: version, sku: sku, api_key: api_key, azure_storage_account: azure_storage_account,
        azure_storage_access_key: azure_storage_access_key, azure_tenant_id: azure_tenant_id, azure_client_id: azure_client_id,
        azure_client_secret: azure_client_secret, container_name: container_name, container_path: container_path
      )
      # Stub azure cli invocation
      allow(@publisher).to receive(:create_azure_sas).and_return sas_response

      stub_request(:get, @publisher.base_url).to_return(status: 200, body: response)
      stub_request(:post, @publisher.base_url+'update').to_return(status: 200)
      stub_request(:post, @publisher.base_url+'stage').to_return(status: 202)
    end

    it 'does not print the API key to stdout or stderr' do
      expect{@publisher.stage}.
        to_not output(/#{@publisher.api_key}/).to_stdout
      expect{@publisher.stage}.
        to_not output(/#{@publisher.api_key}/).to_stderr
    end

    it 'invokes the Azure publisher API' do
      @publisher.stage

      assert_requested(:get, @publisher.base_url) do |req|
        headers = req.headers
        (headers['Accept'] == 'application/json') &&
          (headers['Authorization'] ==  "WAMP apikey=#{@publisher.api_key}") &&
        (headers['X-Protocol-Version'] == '2') &&
        (headers['Content-Type'] == 'application/json')
      end

      assert_requested(:post, @publisher.base_url+'update') do |req|
        headers = req.headers
        (headers['Accept'] == 'application/json') &&
          (headers['Authorization'] ==  "WAMP apikey=#{@publisher.api_key}") &&
        (headers['X-Protocol-Version'] == '2') &&
        (headers['Content-Type'] == 'application/json')

        body = req.body
        expected_body = '{"VirtualMachineImagesByServicePlan":{"2012r2":{"OperatingSystemName":"Windows Server 2012R2","OperatingSystemFamily":"windows","RecommendedVmSizes":["d2-standard-v2","d3-standard-v2","d4-standard-v2"],"IsLocked":true,"PortRules":[],"VirtualMachineImages":[{"VersionId":"1.0.1","VersionLabel":"1.0.1","OsImageUrl":"https://koalapremiumstore.blob.core.windows.net/system/Microsoft.Compute/Images/packer-test/stemcell-osDisk.48d0cb66-bf30-4e0d-8106-774f1fda6fed.vhd?sr=c\u0026sv=2016-05-31\u0026ss=b\u0026srt=co\u0026sp=rl\u0026se=2018-03-20T19:22:16Z\u0026st=2017-03-07T11:22:16Z\u0026spr=https\u0026sig=JWjyPqKjg9cVRUYeeiLpsCyOrvdfIU%2FcTNg7Qg4%2FFNc%3D","IsLocked":true,"DataDiskUrlsByLunNumber":{}},{"VersionId":"1.0.3","VersionLabel":"1.0.3","OsImageUrl":"https://devenvdisks477.blob.core.windows.net/system/Microsoft.Compute/Images/boshtest/cfstem-osDisk.f883362e-1c70-491c-abc4-c90a7d0f4dcc.vhd?sr=c\u0026sv=2016-05-31\u0026ss=b\u0026srt=co\u0026sp=rl\u0026se=2018-03-28T23:33:58Z\u0026st=2017-03-14T15:33:58Z\u0026spr=https\u0026sig=l%2Fhu1slbg3x5KooIQUWWJgbeWHDREwJ2hMAnQU6sBD8%3D","IsLocked":true,"DataDiskUrlsByLunNumber":{}},{"VersionId":"1.0.4","VersionLabel":"1.0.4","OsImageUrl":"https://koalapremiumstore.blob.core.windows.net/system/Microsoft.Compute/Images/packer-test/stemcell-osDisk.e20b8629-838f-4c4b-b16c-44a3a74992f4.vhd?sr=c\u0026sv=2016-05-31\u0026ss=b\u0026srt=co\u0026sp=rl\u0026se=2018-03-31T22:35:08Z\u0026st=2017-03-17T14:35:08Z\u0026spr=https\u0026sig=6iuIJfm5oGZ8pAzLZSyimAUpUrT%2FEIbxeuPfPiaH7XQ%3D","IsLocked":false,"DataDiskUrlsByLunNumber":{}},{"VersionId":"some-version","VersionLabel":"some-version","OsImageUrl":"https://storageaccount.blob.core.windows.net/containername/some-container-path?some-sas","isLocked":false,"DataDiskUrlsByLunNumber":{}}]}},"MarketingDetails":{"en-US":{"Title":"BOSH Azure Windows Stemcell","Summary":"BOSH Azure Windows Stemcell","LongSummary":"Curabitur mattis odio nec nibh porta elementum.","HtmlDescription":"BOSH Azure Windows Stemcell","ServicePlanMarketingDetails":[{"ServicePlanNaturalIdentifier":"2012r2","Title":"BOSH Azure Windows Stemcell","Summary":"Cras eget laoreet ex. Vestibulum tincidunt tempus nisl eget condimentum.","Description":"Nunc non nulla risus. Suspendisse potenti. Donec id orci feugiat metus dignissim placerat. Vestibulum placerat, felis eget rutrum interdum, neque ex molestie est, at mollis ante nibh at sapien. Vivamus venenatis dictum magna et bibendum. Fusce dictum nunc leo, vitae vestibulum nisi vehicula vitae. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam et sapien sapien. Phasellus eu ex ac ligula iaculis placerat eu sit amet tellus. Curabitur ut ante sagittis, dictum purus vitae, volutpat mi. Fusce pharetra viverra rhoncus."}]}},"Categories":[],"ServicePlanDetails":{"2012r2":{"HideSku":false,"WasEverListed":true,"CloudTypes":["PublicAzure"]}}}'
        body == expected_body
      end

      assert_requested(:post, @publisher.base_url+'stage') do |req|
        headers = req.headers
        (headers['Accept'] == 'application/json') &&
          (headers['Authorization'] ==  "WAMP apikey=#{@publisher.api_key}") &&
        (headers['X-Protocol-Version'] == '2') &&
        (headers['Content-Type'] == 'application/json')
      end
    end
  end
end

