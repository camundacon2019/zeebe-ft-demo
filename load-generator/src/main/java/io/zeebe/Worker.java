/*
 * Copyright © 2019 camunda services GmbH (info@camunda.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.zeebe;

import io.zeebe.client.ZeebeClient;
import io.zeebe.client.api.worker.JobWorker;
import io.zeebe.config.AppCfg;

public class Worker extends App {

  private final AppCfg appCfg;

  Worker(AppCfg appCfg) {
    this.appCfg = appCfg;
  }

  @Override
  public void run() {
    final String jobType = "demo";
    final long completionDelay = 300;

    final ZeebeClient client = createZeebeClient();
    printTopology(client);

    final JobWorker worker =
        client
            .newWorker()
            .jobType(jobType)
            .handler(
                (jobClient, job) -> {
                  try {
                    Thread.sleep(completionDelay);
                  } catch (Exception e) {
                    e.printStackTrace();
                  }

                  jobClient.newCompleteCommand(job.getKey()).variables(job.getVariables()).send();
                })
            .open();

    Runtime.getRuntime()
        .addShutdownHook(
            new Thread(
                () -> {
                  worker.close();
                  client.close();
                }));
  }

  private ZeebeClient createZeebeClient() {
    return ZeebeClient.newClientBuilder()
        .brokerContactPoint(appCfg.getBrokerUrl())
        .numJobWorkerExecutionThreads(4)
        .defaultJobWorkerName("demo")
        .withProperties(System.getProperties())
        .build();
  }

  public static void main(String[] args) {
    createApp(Worker::new);
  }
}
